# DMF0043 클라우드 이관 패키지 (재취합본)

> **작성**: 2026-06-04
> **이전 패키지**: `_artifacts/_deploy_packages/old/DMF0043_deploy_2026-06-02/` (참조용 보존, 누락 fix 다수)
> **목적**: 누락된 fix 7건 + 권한 + 종속 객체 cross-check 모두 통합

DMF0043 (기여율 관리 / Contribute Rate) 화면의 클라우드 적용 시 수차례 -9994 SQL Error 발생. 본 패키지는 6 단계의 누적 fix + SCMD_APP 권한 + 마스터 SEED + 종속 객체 cross-check 를 하나도 빠뜨리지 않도록 정렬한 결정판.

---

## 1. 사고 사례 9 단계 (cross-ref) — 모두 해결 완료 2026-06-05

| 단계 | 증상 | 원인 | Fix 파일 |
|---:|---|---|---|
| 1 | `ORA-00904 FN_SCM_STRING_SPLIT 부적합한 식별자` | 클라우드에는 NSCM 표준 `UF_FX_STRING_SPLIT` 만 존재 | `01_SP_BODY/010` body 내 fix |
| 2 | `ORA-00904 COLUMN_VALUE` | `UF_FX_STRING_SPLIT` 반환 컬럼은 `TOKEN` | `01_SP_BODY/010` 동일 |
| 3 | `Page Not Found` (React Router) | FE Router slug `contribute-main` vs DB `MNU_URL='contribution-rate-registration'` | `03_META/030_DMF_MNU_URL_Cloud_Fix.sql` |
| 4 | `PLS-00302 PKG_DMF0043 구성요소 정의` | API_M.API_URL 가 `PKG_DMF0043.P_*` 였으나 실제 객체는 standalone `DMF0043_*` | `03_META/040_DMF0043_API_PROC_Path_Fix.sql` |
| 5 | 같은 PLS-00302 (fix 후에도 동일) | API_M chain 9 row 누락 | `03_META/050_DMF0043_API_BTN_MPG_Full_Resync.sql` |
| 6 | `ORA-01001 cursor invalid` at line 845 | TITLE SP default branch `OPEN O_RC3` vs caller fetch `O_RC1` mismatch | `01_SP_BODY/020` (literal) / `01_SP_BODY/030` (regexp) |
| 7 | `ORA-00936 missing expression` | GT_GMST_TEMP2_2 0 row → 동적 컬럼 0 → v_Query invalid | **`01_SP_BODY/005b` wrapper** (PKG 호출 + 자체 22-col SELECT) |
| 8 | `ORA-00936 재발` | EDIT_FLAG row 의 `DEFAULT_FLAG=NULL` → wrapper 1st UNION 제외 | **`01_SP_BODY/005b` 4th UNION** (EDIT_FLAG 강제 포함 + NOT EXISTS) |
| 9 | `ORA-00918 column ambiguous` | PKG body 의 GT_GMST INSERT 가 DELETE 없이 누적 → 중복 alias | **`01_SP_BODY/005b` STEP 0** (GT_GMST 사전 DELETE) |

### 핵심 fix 파일 = `01_SP_BODY/005b_DMF0043_GET_MAIN_SPREAD_TITLE_PkgWrapper.sql`

3 단계 단일 wrapper 가 7~9 모두 해결:
- **STEP 0**: GT_GMST_TEMP_2 / GT_GMST_TEMP2_2 사전 DELETE (누적 방지)
- **STEP 1**: PKG_DMF0043.P_DMF0043_GET_MAIN_SPREAD_TITLE 호출 (GT_GMST 117 row 적재)
- **STEP 2**: 자체 4 UNION SELECT 를 O_RC1 OPEN (22 컬럼, EDIT_FLAG 강제 포함)
  - 1st UNION : DEFAULT_FLAG='Y' + PR_SCM_EDIT_YN 권한 7 row
  - 2nd UNION : VISIBLE_FLAG='N' DEFAULT_FLAG IS NULL (보통 0 row)
  - 3rd UNION : GT_GMST_TEMP2_2 117 row (동적 월/년 컬럼)
  - **4th UNION : EDIT_FLAG row 강제 포함 (NOT EXISTS 가드)**
- **STEP 3**: O_RC2 / O_RC3 = empty cursor

총 fetch 125 row, caller 정상 동작 확인.

---

## 2. 폴더 구조

```
DMF0043/
├── README.md                                              ← 본 파일
├── 00_DDL/                                                ← 객체/INDEX 사전 확인 (READ-ONLY 위주) + PK 변경
│   ├── 010_DEPENDENT_OBJECTS_CHECK.sql                    ← 종속 PKG/FUNC 존재 + VALID 확인
│   ├── 020_GTT_DMF0043_CHECK.sql                          ← 7개 GTT 존재 확인
│   ├── 030_SCM_MST_SHEET_COLUMNS_PK_NonUnique.sql         ← PK UNIQUE → NON-UNIQUE (1회만)
│   └── 040_INDEX_DMF0043_Verify.sql                       ← 마스터 테이블 INDEX 확인 + 권장
├── 01_SP_BODY/                                            ← SP 본체 (실제 컴파일)
│   ├── 005_DMF0043_GET_MAIN_SPREAD_TITLE_Body.sql         ← ⭐ TITLE SP raw body (caller 핵심 종속, fresh cloud 필수)
│   ├── 010_DMF0043_main_SP_bodies.sql                     ← 9 standalone SP (POPUP 3종 포함: RATE/YEAR/VERSIONPOPUP)
│   ├── 015_DMF0043_GET_MAIN_SPREAD_TITLE_22Col_Fallback.sql   ← TITLE SP default 분기 fallback OPEN 보강
│   ├── 018_DMF0043_GET_MAIN_SPREAD_TITLE_EditYnColRemove.sql  ← TITLE SP 3 SELECT 의 EDIT_YN 23번째 컬럼 제거 (literal REPLACE)
│   ├── 019_DMF0043_GET_MAIN_SPREAD_TITLE_EditYnColRemove_RegexpFix.sql ← 018 fail 시 fallback (REGEXP, whitespace/quote 무관)
│   ├── 020_DMF0043_GET_MAIN_SPREAD_TITLE_OpenRC1_RootFix.sql  ← TITLE SP default branch O_RC3→O_RC1 (literal REPLACE)
│   └── 030_DMF0043_GET_MAIN_SPREAD_TITLE_OpenRC1_RegexpFix.sql ← 020 fail 시 fallback (REGEXP, whitespace-safe)
├── 02_SEED_DATA/                                          ← 마스터 SEED
│   ├── 010_DMF0043_Seed_Version_Data.sql                  ← DM_MST_CONTRIBUTE_VER 3 row
│   ├── 020_DMF0043_Seed_Ratio_MST_DTL.sql                 ← DM_MST_CONTRIBUTE_RATIO_MST 2 + DTL 24
│   ├── 030_DMF0043_SITE_ITEM_AsIs_DimData_Import.sql      ← SCM_MST_SITE_ITEM dim data
│   ├── 040_DMF0043_SITE_ITEM_DimData_BySiteOnly.sql       ← (optional) Site-only variant
│   ├── 050_DMF0043_DTL_TrendPower01_Import.sql            ← (optional) Trend Power dim
│   └── 060_DMF0043_SHEET_COLUMNS_Dedupe.sql               ← DMF0043 8 중복 dedupe (PK 변경 전)
├── 03_META/                                               ← 메타 7-BLOCK + 보강
│   ├── 010_DMF0043_meta_full.sql                          ← 기본 메타 (MSG_M+API_M+MNU_BTN_MPG_M+PROC_M+MNU_M+GR_MNU+GR_BTN)
│   ├── 020_DMF0043_01_meta.sql                            ← View 화면 메타
│   ├── 030_DMF_MNU_URL_Cloud_Fix.sql                      ← slug 'contribute-main' / 'contribute-view' 정합
│   ├── 040_DMF0043_API_PROC_Path_Fix.sql                  ← API_URL/PROC_NM 의 PKG_DMF0043.P_ → standalone
│   └── 050_DMF0043_API_BTN_MPG_Full_Resync.sql            ← API_M + MNU_BTN_MPG + MSG_M 누락 row 보강
├── 04_GRANT_SYNONYM/                                      ← SCMD_APP 권한
│   ├── 010_SCMD_APP_Object_Grants.sql                     ← 포괄적 GRANT (9 SP + 7 GTT + 종속 + 마스터 SELECT)
│   ├── 020_SCMD_APP_Private_Synonyms.sql                  ← private synonym 일괄 (SCMD_APP 세션 실행)
│   └── 030_DMF0043_GUEST_Menu_Btn_Permission.sql          ← GUEST 그룹 메뉴/버튼 권한
└── 05_VERIFY/                                             ← 검증
    ├── 010_Object_Status_Verify.sql                       ← 모든 객체 VALID 확인
    ├── 020_Meta_Chain_Verify.sql                          ← BTN_MPG ↔ API_M ↔ PROC_M chain PASS
    ├── 030_State_Diagnose.sql                             ← 5 DIAG 통합 상태 진단
    └── 040_Caller_Performance_Trace.sql                   ← caller 단계별 timing (timeout 진단)
```

---

## 3. 실행 순서 (필수 준수)

> 모든 SQL 은 **SCM_MGR 세션** 에서 실행. (예외: `04_GRANT_SYNONYM/020_SCMD_APP_Private_Synonyms.sql` 는 SCMD_APP 세션)

### Phase A — 사전 확인 (READ-ONLY)
```
1. 00_DDL/010_DEPENDENT_OBJECTS_CHECK.sql      ← 종속 객체 존재 + VALID 확인
2. 00_DDL/020_GTT_DMF0043_CHECK.sql            ← GTT 7개 + SCMD_APP 권한 확인
3. 00_DDL/040_INDEX_DMF0043_Verify.sql         ← INDEX + 마스터 row count 확인
```
→ 누락 객체 / INVALID 발견 시 Phase B 진행 전에 해결 필수.

### Phase B — 데이터 + 메타 + 구조
```
4. 00_DDL/030_SCM_MST_SHEET_COLUMNS_PK_NonUnique.sql   ← (선택) PK 변경 — DMF0043 dedupe 필요 시
5. 02_SEED_DATA/010 → 020 → 030 → 040 → 050 → 060     ← 6 SEED 순서대로
6. 03_META/010 → 020 → 030 → 040 → 050                ← 5 메타 순서대로
```

### Phase C — SP 본체 + 권한
```
7.  01_SP_BODY/005_DMF0043_GET_MAIN_SPREAD_TITLE_Body.sql    ← TITLE SP raw body (caller 종속) ⭐
8.  01_SP_BODY/010_DMF0043_main_SP_bodies.sql                ← 9 standalone SP (POPUP 3종 포함)
9.  01_SP_BODY/015_..._22Col_Fallback.sql                    ← TITLE SP default 분기 fallback OPEN
10. 01_SP_BODY/018_..._EditYnColRemove.sql                   ← TITLE SP EDIT_YN 컬럼 3건 제거 (literal)
    ※ Patch failed 또는 부분 적용 시 → ORA-06504/24344:
    10'. 005 재실행 (raw body 복구) → 019_..._EditYnColRemove_RegexpFix.sql (whitespace-safe)
11. 01_SP_BODY/020_..._OpenRC1_RootFix.sql                   ← TITLE SP O_RC3→O_RC1 (literal)
    ※ Patch failed 발생 시:
    11'. 01_SP_BODY/030_..._OpenRC1_RegexpFix.sql            ← whitespace-safe fallback
12. 04_GRANT_SYNONYM/010_SCMD_APP_Object_Grants.sql          ← (SCM_MGR) 포괄적 GRANT
13. 04_GRANT_SYNONYM/020_SCMD_APP_Private_Synonyms.sql       ← (SCMD_APP) synonym
14. 04_GRANT_SYNONYM/030_DMF0043_GUEST_Menu_Btn_Permission.sql  ← (SCM_MGR) GUEST 권한
```

### Phase D — 검증
```
15. 05_VERIFY/010_Object_Status_Verify.sql        ← 모든 객체 VALID
16. 05_VERIFY/020_Meta_Chain_Verify.sql           ← chain PASS
17. 05_VERIFY/030_State_Diagnose.sql              ← 5 DIAG 통합
18. 05_VERIFY/040_Caller_Performance_Trace.sql    ← 단계별 timing (timeout 진단)
```

### Phase E — FE 통합 검증 (수동)
```
19. 클라우드 FE 에서 DMF0043 메뉴 진입
20. 조회 클릭 → -9994 없이 grid 데이터 표시
21. DevTools Network 응답 200 + result.o_rc1 row > 0
```

## DMF0043 POPUP 인벤토리 (참고)

| FE 컴포넌트 | sheetName | BE SP | 본 패키지 포함 |
|---|---|---|---|
| ContributeRatePopup | ratePopup | DMF0043_GET_CONTRIBUTE_RATE_POPUP | 01_SP_BODY/010 [6/9] |
| VersionPopup (Main) | versionPopup | DMF0043_GET_CONT_VIEW_VERSIONPOPUP | 01_SP_BODY/010 [7/9] |
| Year DropDown (combo) | yearPopup | DMF0043_GET_CONTRIBUTE_YEAR_POPUP | 01_SP_BODY/010 [5/9] |
| Version Dropdown | version | DMF0043_GET_MAIN_VARSION_DATA | 01_SP_BODY/010 [3/9] |
| (공용) Column Title Set | (DMF0043_01) | DMF0002_GET_TITLESET_POPUP | 00_DDL/010 cross-check (별도 deploy) |

> SAVE 동작은 메인 `DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO` 사용 (별도 POPUP SAVE SP 없음). 메타 BTN_MPG 의 `version SAVE` 는 `DMF0043_SAVE_DM_MST_CONTRIBUTE_VER` 호출.

## 파일 형식 정책

- **모든 SQL 은 SQL*Plus 표준** (`SET DEFINE OFF`, `SET SERVEROUTPUT ON`, `PROMPT`, `/`, `COMMIT`)
- **DBeaver 에서도 동일 실행 가능** (script 모드 또는 statement 별)
- **파일명에 `_DBeaver` suffix 없음** — 단일 형식으로 통일

---

## 4. 단계별 합격 기준

| Phase | 합격 기준 |
|---|---|
| A.1 | DIAG 1 4 row + STATUS=VALID 모두. DIAG 2 row 0 (누락 없음). DIAG 3 row 0 (INVALID 없음). |
| A.2 | DIAG 1 7 row + TEMPORARY=Y. DIAG 4 컬럼 22개. |
| A.3 | 마스터 row count 정상. SHEET_COLUMNS PK NON-UNIQUE 권장. |
| B.5 | SEED 6 row 0건 (INSERT NOT EXISTS — 이미 있으면 SKIP). |
| B.6 | 메타 INSERT row 합계 (10 API + 10 BTN + 10 MSG + PROC_M 등) — 멱등이라 재실행 OK. |
| C.7 | 모든 9 SP COMPILED. INVALID 0건. |
| C.8 | "OK: ... patched. default branch now opens O_RC1." 또는 "이미 fix 적용됨 — SKIP" |
| C.9-10 | OK + SKIP 카운트만. ERR 카운트 0. |
| C.11 | INSERT row > 0 (멱등 NOT EXISTS). |
| D.12 | VERIFY 1 모두 VALID. VERIFY 2/3 row 0. VERIFY 5 row 0. |
| D.13 | VERIFY 1 PASS. VERIFY 2 row 0. VERIFY 3 모든 row PASS. VERIFY 4 MENU=2 BTN>0. VERIFY 5 7 row. |
| D.14 | DIAG 4 `O_RC1 rows = -99` (column mismatch 정상). DIAG 3 모두 O_RC1. |
| D.15 | Total elapsed < 30s. caller cursor OPEN 정상. GT_TITLE = 22. |
| E.18 | FE grid 데이터 표시 + Network 200 OK. |

---

## 5. 사고 시 Rollback

| 변경 종류 | Rollback 방법 |
|---|---|
| 03_META/030, 040, 050 (UPDATE/INSERT) | 멱등 — 재실행 안전. 단, MNU_URL 변경은 운영 영향 가능성 — 이전 값 backup: `SELECT mnu_id, mnu_url FROM scm_adm_mnu_m WHERE mnu_id LIKE 'DMF0043%';` 미리 캡쳐 |
| 01_SP_BODY/010 SP 재컴파일 | 이전 backup: `_artifacts/_bulk_fix_v2_converted/_backup_2026-06-01/04_Package_PKG_DMF0043.sql` 참조 |
| 01_SP_BODY/020 TITLE SP fix | Rollback: `OPEN O_RC1 FOR` → `OPEN O_RC3 FOR` REPLACE 후 재컴파일 (사고 6 재현이 되므로 보통 불필요) |
| 02_SEED_DATA/060 SHEET_COLUMNS_Dedupe | NOT EXISTS 패턴 — 멱등 |
| 00_DDL/030 PK 변경 | UNIQUE 복원: BLOCK 5 의 ROLLBACK SQL 사용 |
| 04_GRANT_SYNONYM/010, 020 | `REVOKE EXECUTE/SELECT ON ... FROM SCMD_APP` 또는 `DROP SYNONYM ...` (보통 불필요) |
| 04_GRANT_SYNONYM/030 GUEST 권한 | `DELETE FROM scm_adm_user_gr_mnu_mpg_m WHERE user_gr_id='GUEST' AND mnu_id IN ('DMF0043','DMF0043_01');` |

---

## 6. 이전 패키지 (`old/DMF0043_deploy_2026-06-02/`) 와의 차이

| 항목 | 이전 | 본 패키지 |
|---|---|---|
| 폴더 구조 | 02_DB_Meta_SQL / 03_SP_PKG / 04_Verify 등 3 폴더 + 산재된 fix 파일 | 00_DDL / 01_SP_BODY / 02_SEED_DATA / 03_META / 04_GRANT_SYNONYM / 05_VERIFY 6 폴더 정렬 |
| 누락 | 종속 객체 확인 / GTT 확인 / INDEX 확인 / GRANT 포괄 / synonym / GUEST 권한 / caller 성능 진단 | 모두 포함 |
| 실행 순서 | 명시적 README 없음 | Phase A→B→C→D→E 명시 |
| 멱등성 | 일부 fix 만 멱등 | 모든 파일 멱등 (NOT EXISTS / WHERE 가드 / BEGIN/EXCEPTION) |
| SEED 데이터 | 일부 분기에서만 카피 | 6 파일 모두 통합 (optional 2 표시) |
| 신규 4 진단 SQL | 없음 | `00_DDL/010, 020, 040` + `05_VERIFY/010, 020, 040` 5건 신규 |

---

## 7. 진단 도구 정리 (이번 세션 확정 사실)

이번 세션의 진단 결과 (2026-06-04 21:12):
- **SP fix 정상 적용**: DMF0043_GET_MAIN_SPREAD_TITLE LAST_DDL = 2026-06-04 21:12:33
- **O_RC1 정상**: `OPEN O_RC1 FOR` 1건, `O_RC3 FOR` 0건 (DIAG 3)
- **caller 단독 호출 검증**: O_RC1 22-컬럼 cursor 정상 OPEN (DIAG 4 의 `-99` = expected column mismatch)
- **남은 이슈**: caller `DMF0043_GET_CONTRIBUTE_MAIN_DATA` 가 DBeaver 에서 ORA-01013 timeout. → `05_VERIFY/040` 으로 어느 STEP 이 느린지 식별 필요. 클라우드 INDEX / 통계 / 데이터 size 가 의심 후보.

---

## 8. 핵심 파일 위치

- **본 패키지 root**: `_artifacts/_deploy_packages/DMF0043/`
- **이전 (참조용)**: `_artifacts/_deploy_packages/old/DMF0043_deploy_2026-06-02/`
- **원본 source 카피**: `_artifacts/41_DMF0043_meta.sql`, `46~67_DMF0043_*.sql`, `33_DMF_MENU_URL_GUEST_Perm_Fix.sql`

---

## 9. 관련 룰 / 메모리

- 룰: `Doc/_dev_rules/22_PACKAGE_ARTIFACTS.md` (이관 패키지 표준)
- 룰: `Doc/_dev_rules/11_AUTH_SECURITY.md` (권한)
- 룰: `Doc/_dev_rules/08_SCREEN_REGISTRATION.md` (메타 7-BLOCK)
- 메모리: `feedback_dbeaver_sql_mandatory_grep.md` (SQL*Plus 토큰 grep)
- 메모리: `feedback_sql_idempotent_insert_all.md` (멱등 INSERT 패턴)
- 메모리: `feedback_proc_meta_mandatory.md` (PROC 메타 자동 변환)
- 메모리: `feedback_mnu_uppr_case_standard.md` (MNU_URL slug)

# DMF0043_01 (Contribute View) 클라우드 이관 패키지

> **작성**: 2026-06-05
> **이전 패키지**: `_artifacts/_deploy_packages/old/DMF0043_01_deploy_2026-06-02/` (참조용 보존)
> **선행 의존**: ⚠ **DMF0043 deploy 패키지 (`_artifacts/_deploy_packages/DMF0043/`) 먼저 적용 필수**

DMF0043_01 (Contribute View) 는 DMF0043 의 view-only 변형. 5 sheet (main / mainTitle / version / ratePopup / versionPopup) + titleSet popup (DMF0002 공용).

## 1. DMF0043 9 사고 chain cross-ref

| # | 사고 (DMF0043) | DMF0043_01 위험 | 본 패키지 대응 |
|---:|---|---|---|
| 1 | FN_SCM_STRING_SPLIT 미존재 | LOW (공유 SP 사용) | `00_DDL/010` 종속 객체 확인 |
| 2 | COLUMN_VALUE → TOKEN | LOW | (DMF0043 fix 자동 상속) |
| 3 | MNU_URL slug 불일치 | **HIGH** — `contribute-view` | `03_META/040_MNU_URL_Cloud_Fix.sql` |
| 4 | API_M PKG path | MEDIUM — 일부 row 정합 필요 | `03_META/050_API_PROC_Path_Fix.sql` |
| 5 | API_M chain 끊김 | MEDIUM — 5 BTN_MPG 등록 | `03_META/010_meta_full.sql` (5 BTN) + `020_TitleSet_Meta.sql` (titleSet) |
| 6 | SPREAD_TITLE default O_RC3 | LOW (DMF0043 SPREAD_TITLE 와 다른 SP — SALES_LIST_SPREAD_TITLE 는 단일 SELECT) | (자동 상속) |
| 7-9 | GT_GMST 관련 사고 | LOW (DMF0043 wrapper 가 GT_GMST 채움) | DMF0043 선적용 의존 |

## 2. 폴더 구조

```
DMF0043_01/
├── README.md
├── 00_DDL/
│   ├── 010_DEPENDENT_OBJECTS_CHECK.sql     ← 종속 SP/PKG/공용 객체 STATUS
│   ├── 020_GTT_DMF0043_01_CHECK.sql        ← DMF0043 GTT 공유 인벤토리
│   └── 030_INDEX_DMF0043_01_Verify.sql     ← 마스터 INDEX + SHEET_COLUMNS row
├── 01_FE/                                   ← FE 파일 (contribute-view 16 파일)
│   └── contribute-view/                     ← ContributeView.tsx + components + modals + hooks + store
├── 01_SP_BODY/
│   └── 010_DMF0002_titleset_SP_body.sql    ← DMF0002_GET_TITLESET_POPUP (공용, carrying)
├── 02_SEED_DATA/
│   └── README.md                            ← ⓘ 빈 폴더 — DMF0043 와 데이터 공유 (DMF0043 SEED 적용으로 충족)
├── 03_META/
│   ├── 010_DMF0043_01_meta_full.sql        ← 7-BLOCK 메타 (5 BTN)
│   ├── 020_DMF0043_01_TitleSet_Meta.sql    ← titleSet sheet (DMF0002 공용 SP routing)
│   ├── 030_DMF0043_01_KO_Name_Update.sql   ← i18n KO 명칭
│   ├── 040_DMF0043_01_MNU_URL_Cloud_Fix.sql  ← slug 'contribute-view' 정합
│   └── 050_DMF0043_01_API_PROC_Path_Fix.sql ← PKG path → standalone
├── 04_GRANT_SYNONYM/
│   ├── 010_SCMD_APP_Object_Grants.sql      ← 공유 SP/GTT/마스터 GRANT
│   ├── 020_SCMD_APP_Private_Synonyms.sql   ← synonym
│   └── 030_DMF0043_01_GUEST_Menu_Btn_Permission.sql
└── 05_VERIFY/
    ├── 010_Object_Status_Verify.sql
    ├── 020_Meta_Chain_Verify.sql
    ├── 030_Caller_Test.sql
    └── 050_DMF0043_01_VersionPopup_Diagnose.sql  ← VersionPopup 호출 진단
```

## 3. 실행 순서

```
⚠ 전제 : DMF0043 deploy 패키지 모두 적용 완료

Phase A (READ-ONLY 사전 확인)
  1. 00_DDL/010 → 020 → 030

Phase B (메타 + SEED)
  2. 02_SEED_DATA (비어있음, skip)
  3. 03_META/010 → 020 → 030 → 040 → 050

Phase C (SP body + 권한)
  4. 01_SP_BODY/010 (DMF0002 titleset SP body)
  5. 04_GRANT_SYNONYM/010 → 020 (SCMD_APP 세션) → 030

Phase D (검증)
  6. 05_VERIFY/010 → 020 → 030 → 050

Phase E (FE 통합 검증 — 수동)
  7. 클라우드 FE 에서 DMF0043_01 메뉴 진입 → 조회 클릭 → grid 표시 + titleSet popup 정상
```

## 4. 합격 기준

| Phase | 기준 |
|---|---|
| A.1 | DEPENDENT_OBJECTS DIAG 1 9 row + STATUS=VALID. DIAG 2 누락 0 |
| B.3 | 메타 5 BTN_MPG + 1 titleSet INSERT (또는 멱등 SKIP) |
| C.5 | GRANT OK / SKIP 만. ERR 0 |
| D.6 | VERIFY 1-4 모두 PASS. caller 정상 종료 + cursor OPEN |
| E.7 | FE grid 데이터 표시 + titleSet column setup popup 정상 |

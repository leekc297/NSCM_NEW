# DMF0008 (ERP-EDI Master) 클라우드 이관 패키지

> **작성**: 2026-06-05
> **이전 패키지**: `_artifacts/_deploy_packages/old/DMF0008_deploy_2026-06-02/` (참조용 보존)

DMF0008 (ERP-EDI Master) — 4 sheet (repair / sspm / summary / salesSite) + Update History wrapper.

## 1. DMF0043 9 사고 chain cross-ref

| # | 사고 (DMF0043) | DMF0008 위험 | 본 패키지 대응 |
|---:|---|---|---|
| 1 | FN_SCM_STRING_SPLIT | LOW (사용 없음) | `00_DDL/010` |
| 2 | COLUMN_VALUE → TOKEN | LOW | — |
| 3 | MNU_URL slug 불일치 | **HIGH** — `erp-edi-master` | `03_META/060_MNU_URL_Cloud_Fix.sql` |
| 4 | API_M PKG path | LOW (모두 standalone path) | — |
| 5 | API_M chain 끊김 | MEDIUM (11+ row) | `03_META/010~050` 메타 등록 검증 |
| 6 | SPREAD_TITLE O_RC3 | LOW (PIVOT 미사용) | — |
| 7-9 | GT_GMST 관련 | LOW (GTT 미사용) | — |

## 2. 폴더 구조

```
DMF0008/
├── README.md
├── 00_DDL/
│   ├── 010_DEPENDENT_OBJECTS_CHECK.sql
│   ├── 020_GTT_DMF0008_CHECK.sql
│   └── 030_INDEX_DMF0008_Verify.sql
├── 01_FE/                                      ← FE 파일 (erp-edi-master 8 파일)
│   └── erp-edi-master/
├── 01_SP_BODY/
│   └── 010_DMF0008_updateHistory_SP_bodies.sql  ← wrapper + 공용 SP body
├── 02_SEED_DATA/
│   └── README.md                                ← ⓘ 빈 폴더 — 클라우드 운영 데이터 사용
├── 03_META/
│   ├── 010_DMF0008_meta_full.sql               ← 초기 메타 (6 SP)
│   ├── 020_DMF0008_phase1_meta.sql             ← Phase 1 (SUMMARY)
│   ├── 030_DMF0008_phase2_meta.sql             ← Phase 2 (REPAIR/SALES_SITE/SSPM)
│   ├── 040_DMF0008_status_update_meta.sql      ← STATUS_UPDATE button 메타
│   ├── 050_DMF0008_updateHistory_meta_boost.sql ← Update History 메타 보강
│   └── 060_DMF0008_MNU_URL_Cloud_Fix.sql        ← slug 'erp-edi-master' 정합
├── 04_GRANT_SYNONYM/
│   ├── 010_SCMD_APP_Object_Grants.sql
│   ├── 020_SCMD_APP_Private_Synonyms.sql
│   └── 030_DMF0008_GUEST_Menu_Btn_Permission.sql
└── 05_VERIFY/
    ├── 010_Object_Status_Verify.sql
    ├── 020_Meta_Chain_Verify.sql
    ├── 030_Caller_Test.sql                      ← 4 sheet caller 호출 검증
    └── 050_DMF0008_updateHistory_Diagnose.sql
```

## 3. 실행 순서

```
Phase A : 00_DDL/010 → 020 → 030
Phase B : 02_SEED_DATA (skip — 비어있음)
        : 03_META/010 → 020 → 030 → 040 → 050 → 060
Phase C : 01_SP_BODY/010
        : 04_GRANT_SYNONYM/010 → 020 (SCMD_APP) → 030
Phase D : 05_VERIFY/010 → 020 → 030 → 050
Phase E : FE 클라우드 진입 → DMF0008 → 4 sheet 모두 조회 검증
```

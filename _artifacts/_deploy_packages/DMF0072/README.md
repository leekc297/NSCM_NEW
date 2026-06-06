# DMF0072 (NN Master Mapping) 클라우드 이관 패키지

> **작성**: 2026-06-05
> **이전 패키지**: `_artifacts/_deploy_packages/old/DMF0072_deploy_2026-06-02/` (참조용 보존)

DMF0072 (NN Master Mapping) — 격차 A multi-select Division + 4 lookup combo + Project/Item popup + Team SP. UF_FX_STRING_SPLITFORIN 32회 사용.

## 1. DMF0043 9 사고 chain cross-ref

| # | 사고 (DMF0043) | DMF0072 위험 | 본 패키지 대응 |
|---:|---|---|---|
| 1 | FN_SCM_STRING_SPLIT | LOW (UF_FX_STRING_SPLIT/SPLITFORIN 정확) | `00_DDL/010` |
| 2 | COLUMN_VALUE → TOKEN | **MEDIUM** (SPLITFORIN 32회) | `05_VERIFY/030` wrapper ALL + COLUMN_VALUE 검증 |
| 3 | MNU_URL slug 불일치 | LOW (이미 정합 가능성 높음) | `03_META/050_MNU_URL_Cloud_Fix.sql` |
| 4 | API_M PKG path | LOW (모두 standalone) | — |
| 5 | API_M chain 끊김 | MEDIUM (lookup 4 + popup 2) | `03_META/010~040` 메타 보강 |
| 6 | SPREAD_TITLE O_RC3 | LOW (PIVOT 미사용) | — |
| 7-9 | GT_GMST 관련 | LOW (WITH CTE 패턴, GTT 미사용) | — |

**특수 위험**: wrapper 'ALL' → '' 변환 안티패턴 (52_lookup_sp_fix 에서 회피 처리됨) → `05_VERIFY/030` 검증.

## 2. 폴더 구조

```
DMF0072/
├── README.md
├── 00_DDL/
│   ├── 010_DEPENDENT_OBJECTS_CHECK.sql
│   ├── 020_GTT_DMF0072_CHECK.sql
│   └── 030_INDEX_DMF0072_Verify.sql
├── 01_FE/                                      ← FE 7 파일 (nn-master-mapping + ItemByDivisionModal 확장)
│   ├── nn-master-mapping/
│   └── shared-modal/ItemByDivisionModal.tsx
├── 01_SP_BODY/
│   ├── 010_DMF0072_lookup_sp_fix.sql           ← 4 lookup wrapper (sesUserId/mnuId 추가, ALL 처리)
│   ├── 020_DMF0072_TEAM_LIST_sp_body.sql       ← Team SP 본체 (As-Is 1:1)
│   ├── 030_DMF0072_popup_sp_create.sql         ← Project + Item Popup SP 신규
│   └── 040_DMF0072_lookup_SP_bodies.sql        ← Phase 보강 SP bodies
├── 02_SEED_DATA/
│   └── README.md                                ← ⓘ 빈 폴더 — 클라우드 운영 데이터
├── 03_META/
│   ├── 010_DMF0072_meta_full.sql               ← 32 PROC_M 컬럼
│   ├── 020_DMF0072_popup_meta.sql              ← projectPopup + itemPopup 메타
│   ├── 030_COM0008_sheet_columns_dedupe.sql    ← (공용) COM0008 sheet_columns 34→17 dedupe
│   ├── 040_DMF0072_lookup_meta_boost.sql       ← lookup 4종 메타 보강
│   └── 050_DMF0072_MNU_URL_Cloud_Fix.sql       ← slug 'nn-master-mapping' 정합
├── 04_GRANT_SYNONYM/
│   ├── 010_SCMD_APP_Object_Grants.sql
│   ├── 020_SCMD_APP_Private_Synonyms.sql
│   └── 030_DMF0072_GUEST_Menu_Btn_Permission.sql
└── 05_VERIFY/
    ├── 010_Object_Status_Verify.sql
    ├── 020_Meta_Chain_Verify.sql
    ├── 030_Caller_Test_Wrapper_ALL.sql          ← ⭐ wrapper 'ALL' + UF_FX_STRING_SPLITFORIN 검증
    ├── 040_DMF0072_lookup_SP_bodies_Verify.sql
    └── 050_DMF0072_popup_meta_Verify.sql
```

## 3. 실행 순서

```
Phase A : 00_DDL/010 → 020 → 030
Phase B : 02_SEED_DATA (skip — 비어있음)
        : 03_META/010 → 020 → 030 → 040 → 050
Phase C : 01_SP_BODY/010 → 020 → 030 → 040
        : 04_GRANT_SYNONYM/010 → 020 (SCMD_APP) → 030
Phase D : 05_VERIFY/010 → 020 → 030 → 040 → 050
Phase E : FE 클라우드 진입 → DMF0072 → main + lookup 4 + popup 2 모두 검증
```

## 4. 합격 기준

| Phase | 기준 |
|---|---|
| A.1 | DMF0072 SP 8 + PKG_DMF0072 STATUS=VALID. UF_FX_STRING_SPLITFORIN 존재 |
| B | 메타 chain PASS (8 BTN_MPG row 모두) |
| C | wrapper / Team / popup SP 모두 컴파일 OK |
| D.030 | wrapper ALL 호출 정상 + lookup 4 + popup 2 모두 OK |
| E | FE multi-select 동작 + Project/Item popup 데이터 표시 |

## 5. 특수 사고 패턴 (DMF0072 만)

| 사고 | 회피 처리 |
|---|---|
| wrapper 'ALL' → '' 변환 (메모리 `feedback_wrapper_sp_no_all_transform`) | `01_SP_BODY/010` 가 'ALL' 그대로 전달 (split 시 0 row → 안티패턴 회피) |
| UF_FX_STRING_SPLITFORIN COLUMN_VALUE vs TOKEN | 함수 시그니처가 COLUMN_VALUE 반환 (TABLE OF VARCHAR2). 정상 |
| Wijmo 계층 cell merge HierarchicalMergeManager | FE 측 처리 (01_FE/nn-master-mapping/NnMasterMapping.tsx) |

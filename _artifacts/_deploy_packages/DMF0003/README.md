# DMF0003 (MKT FCST — Market Forecast) 풀스택 이관 패키지

> **작성**: 2026-06-07
> **참조 계획**: `C:\Users\ejene\.claude\plans\goofy-percolating-island.md`
> **사용자 결정**: 7-Phase 단계별 PR / AS-IS 1:1 보존 / FE+BE+SQL 병렬 / **3 변형 모두 작업**

## 0. 작업 범위 — 3 변형 모두 (사용자 결정 2026-06-07)

DMF0003 은 AS-IS GSCM 에서 3 변형으로 존재. 분석 MD 폴더 / xlsx / Mockup 모두 3 셋. **3 변형 모두 풀스택 이관 대상**:

| 변형 | .cs lines | Designer | 의미 | Initial | 변형 의도 |
|---|---:|---:|---|---|---|
| **DMF0003_MktFcst** | 5,920 | 1,662 | 원본 (legacy) | 2017-11-09 | 최초 버전 |
| **DMF0003_1_MktFcst** | **7,056** | 2,750 | **메인 1순위** | 2017-11-09 | 운영 메인 (분석 MD 8종 완비) |
| **DMF0003_T_MktFcst** | 5,734 | 1,661 | 속도개선 (Tuning) | 2023-10-23 | 성능 향상 시도 (dev125812) |

- AS-IS namespace 동일 `GSCM.DM.Plan.UIL`, 클래스명 만 다름 (`DMF0003_MktFcst` / `DMF0003_1_MktFcst` / `DMF0003_T_MktFcst`).
- 핸들러 `btnCutOff_Click` 3 변형 모두 존재 — VersionCutOff popup 호출 발견 (계획에서 "공용 대용" 으로 결정, `__asis-mapping__.md` 명시).
- POPUP 6 클래스: MatsterChg / PR / PRHistory / SspSync / SspSyncCompare / CustDemandAnalysis (deprecated 코드 보존, 호출 X). 분석 MD 도 5 POPUP + VersionCutOff 인벤토리 별도 보유.

## 1. AS-IS 정량 (anti-simplification 기준 정밀)

DMF0003_1_MktFcst (메인 1순위) 기준 (`Doc/_analysis/domain_DM/screens/DMF0003_1_MktFcst/analysis.md`):
- 컨트롤 (Designer 필드) **6** / 이벤트 핸들러 v3 **36** / Spread (FpSpread) **3** / Sheet 변수 **3** / Endpoint (FoxDataRequest) **20** / DefColumns 그룹 **3** / 총 Grid 컬럼 **70**
- 호출 SP **23** / Validation **154** (Division 분기 114 + GMessageBox 20 + others 20) / Expression **117** (LockRange 80 + 합계 32 + SUM 헤더 5)
- 조회조건 **18 필드** / Button **16** (CRUD 6 + Lookup 3 + 특화 7)
- 호출 POPUP **6 클래스** (공용 4 + 전용 5 + deprecated 1) — VersionCutOff 는 SCM 공용 대용

## 2. 7-Phase 작업 계획 요약 (Phase 별 PR)

| Phase | 브랜치 | 산출물 | 범위 |
|:-:|---|---|---|
| **P1** | `feature/dmf0003-p1-foundation` | 메타 7-BLOCK + Router + 화면 진입 + 단순 조회 (3 변형 메뉴 등록 + 메인 _1_ skeleton) | Foundation |
| **P2** | `feature/dmf0003-p2-mutation` | Edit/Insert/Delete/Save + 154 validation + Division 3-way | Main Mutation |
| **P3** | `feature/dmf0003-p3-pivot` | 동적 PIVOT (DAILY/WEEKLY/MONTHLY) + 117 expression | Dynamic Cols |
| **P4** | `feature/dmf0003-p4-subgrids` | spdSub1 (PSI) + spdSub2 (Car) + multi-sheet | Sub-Grids |
| **P5** | `feature/dmf0003-p5-popups` | 5 신규 POPUP + CustDemand deprecated 보존 | Popups |
| **P6** | `feature/dmf0003-p6-business-rules` | SSP 색상 + 8주 + Calc + Excel + Report | Business |
| **P7** | `feature/dmf0003-p7-gaps-deploy` | G9/G10 + i18n + 4축 매핑 + deploy zip | Gaps + Final |

## 3. 폴더 구조

```
DMF0003/
├── README.md
├── 00_DDL/                  ← 변경 없음 가정 (DM_ANL_MKT_* 기존 테이블 사용). 변경 발생 시 005_DDL_changes.sql
├── 01_FE/                   ← FE artifacts (manifest + 참조 산출물). 본 폴더는 nscm-fe 의 mirror X — README + manifest 만
├── 01_SP_BODY/              ← 23 SP body (3 변형 공유 / 각자 다른 경우 prefix _T_ 등으로 구분)
│   ├── 010_DMF0003_GET_BUCKET_TYPE_CODE.sql
│   ├── 020_DMF0003_GET_MKT_FCST_DATA.sql           (메인 GET — _1_ + _T_ + 원본 비교 후 결정)
│   ├── 030_DMF0003_SAVE_MKT_FCST.sql
│   └── ... (Phase 별 추가)
├── 02_SEED_DATA/            ← Bucket types / Qty types / Report bucket (멱등 MERGE)
├── 03_META/                 ← 7-BLOCK 메타 SQL (Phase 별 augment)
│   ├── 005_Register_DMF0003_3variants_in_Demand_Master.sql  (BLOCK2 MNU — 3 화면 메뉴 등록)
│   ├── 010_DMF0003_meta_full.sql                            (BLOCK 1/3/4/5/6/7)
│   ├── 020_DMF0003_p2_save_meta.sql                         (P2 augment)
│   ├── 030_DMF0003_p3_pivot_meta.sql                        (P3 augment)
│   ├── 040_DMF0003_p4_subgrid_meta.sql                      (P4)
│   ├── 050_DMF0003_p5_popup_meta.sql                        (P5)
│   └── 060_DMF0003_p7_i18n_finalize.sql                     (P7)
├── 04_GRANT_SYNONYM/        ← SCMD_APP grant + synonym (자매 DMF0072 패턴)
│   ├── 010_SCMD_APP_Object_Grants.sql
│   ├── 020_SCMD_APP_Private_Synonyms.sql
│   └── 030_DMF0003_GUEST_Menu_Btn_Permission.sql
└── 05_VERIFY/               ← 4-파일 세트 (sqlplus / DBeaver / Verify / Diagnose)
    ├── 010_Object_Status_Verify.sql      (ALL_OBJECTS status=VALID)
    ├── 020_Meta_Chain_Verify.sql         (MNU↔URL↔PROC_M↔BTN_MPG↔USER_GR 5-join)
    ├── 030_Caller_Test.sql               (sample EXEC per SP)
    └── 040_Diagnose_Empty_Data.sql       (row-count + 권한 진단)
```

## 4. 메뉴 등록 (BLOCK2 MNU) — 3 화면 결정 필요

`005_Register_DMF0003_3variants_in_Demand_Master.sql` 작성 시 다음 cross-check:

- **메인 _1_MktFcst**: `MENU_ID='DMF0003'` 또는 `'DMF0003_1'` ? — AS-IS DB 의 SCM_ADM_MNU_M cross-check (LGCE_SCMDEV sqlcmd)
- **원본 _MktFcst**: `MENU_ID='DMF0003_M'` ? (deprecated → 메뉴 비활성 또는 ADMIN 만 노출)
- **속도개선 _T_MktFcst**: `MENU_ID='DMF0003_T'` ? (Tuning — 별도 메뉴 또는 메인 대체)

AS-IS DB cross-check 시 SCM_ADM_MNU_M.MENU_ID LIKE 'DMF0003%' 결과 기준 결정. Phase 1 작업 첫 단계.

## 5. 실행 순서 (자매 DMF0072 패턴 동등)

```
Phase A : 00_DDL/ (변경 시) → 002_DDL_changes.sql
Phase B : 02_SEED_DATA/ → 03_META/ (Phase 순 005 → 010 → 020 → ...)
Phase C : 01_SP_BODY/ (Phase 순 010 → 020 → ...) → 04_GRANT_SYNONYM/
Phase D : 05_VERIFY/ (010 → 020 → 030 → 040)
Phase E : FE 진입 → DMF0003 → 3 변형 메뉴 검증 → 각 화면 진입 + 동작 확인
```

## 6. PR 머지 게이트 (모든 PR 적용)

1. **Anti-simplification**: AS-IS feature coverage 표 + 0 omissions
2. **13 룰 grep**: 위반 0
3. **AS-IS 4축 매핑**: Event/API/Validation/Expression 100%
4. **메타 SQL 7-BLOCK**: 멱등 (NOT EXISTS, 재실행 0 row 추가)
5. **4-파일 SQL 세트**: Object_Status / Meta_Chain / Caller_Test / Diagnose 모두 PASS
6. **격차**: G9 (의무) / G10 (선택) — P7 PR
7. **빌드 + 런타임**: lint 0 / type-check 0 / build success / 화면 동작 검증

## 7. 다음 단계

1. **Task 2**: AS-IS 3 변형 .cs / Designer.cs 정밀 read (메인 7,056 lines + 5 popup .cs + 원본 5,920 + Tuning 5,734)
2. **Task 3**: AS-IS DB sqlcmd cross-check — `SCM_ADM_MNU_M.MENU_ID LIKE 'DMF0003%'` + `SP body` 정확 추출 (23 SP)
3. **Task 4**: 자매 화면 DMF0020 / DMF0007 / DMF0072 표준 패턴 정밀 grep
4. **Task 5**: 메타 SQL 7-BLOCK 1차 (005 + 010) 작성
5. **Task 6**: SP body 6건 (Phase 1 범위) 작성
6. **Task 7**: 4-파일 Verify SQL 세트 + DB 적재 검증
7. **Task 8**: FE 12 파일 작성 (Phase 1 범위, _1_MktFcst 우선)
8. **Task 9**: Router + i18n 1차 등록
9. **Task 10**: Phase 1 PR 검증 + 4축 매핑 표 1차 작성

## 8. 변경 이력

- 2026-06-07: 패키지 초기 작성. 3 변형 작업 결정 반영. 자매 DMF0072 패턴 적용.

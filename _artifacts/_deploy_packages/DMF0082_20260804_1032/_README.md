# DMF0082 (Fcst&Price MGMT / forecast-price) — 클라우드 이관 패키지 v2026-08-04

> **성격**: 사내(OCGSCMD_P01) 적용 완료 · 클라우드 미적용 누적분의 **통합 취합 패키지** (self-contained).
> PKG SPEC/BODY 는 2026-08-04 사내 **live 덤프**라 7/22 이후 body 계열 변경 전부(하단 취합표 ①~⑥)를 포함한다.
> 메타 SQL 은 전부 **사내 실측 덤프 → INSERT-only(NOT EXISTS)** — 클라우드 기존재 row 무변경 (2026-07-24 사용자 확정).
> 유일한 예외 = `sql/03B`(PROC_M GET 2종 재정렬, DELETE→INSERT) — **90_VERIFY 점검 후 사용자 승인 하에 실행** (SYS0011 선례).

작성: 2026-08-04 | 화면: **DMF0082** (Fcst&Price MGMT) | 도메인 `demand` | slug `forecast-price`

---

## 1. ⭐ 이관대상목록 취합표 (사내 적용 이력 → 본 패키지 커버 매핑)

| # | 사내 적용일 | 변경 내용 | 본 패키지 커버 파일 | 구(舊) 패키지 |
|---|---|---|---|---|
| ① | 2026-07-22 | GET W/M 분기 복원 + SORT_KEY 999 원복 + GT_DMF0082_MF_SP 4컬럼 | `sp/02` (body 포함) + `sp/00` (GTT DDL 최신) | DMF0082_20260722_1050 (대체됨) |
| ② | 2026-07-23 | **PKG 취합** — standalone 7종 PKG 합류 (멤버 12) | `sp/01·02` + `sql/03A` (PROC_M 전 멤버) | DMF0082_PKG_CONSOLIDATION_20260723 (대체됨) |
| ③ | 2026-07-23 | 콤보 AS-IS 정합 (BizType 등 5UI 일괄분 중 DMF0082) | `sql/05` (CMBO 12종 실측 덤프) | DMF0082_COMBO_ASIS_ALIGN_20260723 (대체됨) |
| ④ | 2026-07-24 | 환율 Modal ADMIN 편집/저장 (PKG_DMF0000 + 배선 9행 + MSG00689) | FE=`fe/`(최신 스냅샷 우선) / 메타=`sql/02·03A·07` 포함. **PKG_DMF0000 SPEC/BODY 는 본 패키지 미포함** | **DMF0082_EXCHANGE_SAVE_20260724_1241 의 `sp/` 만 선행 실행** ⭐ |
| ⑤ | 2026-07-30 | div82=81 경로 편입 + PK 센티널 '-' 정규화 + SHEET DIV82 메타 | `sp/02` (body) + `sql/04` (SHEET_COLUMNS 69·MEASURE 14 전 행) | DBWORK_7UI_PKSENTINEL_TRUNC_20260730_2301 중 DMF0082 분 (대체됨) |
| ⑥ | 2026-07-31 | 성능 튜닝 (partition pruning·ITEM1 prefix·MERGE swap·dynsampling=2) | `sp/02` (body) | DBWORK_DMF0082_TUNING_20260731_1350 (대체됨 — 00C 클라우드 프로파일 점검은 참조 가치) |
| ⑦ | 2026-08-04 | **Plant Site 조회조건 신설** (GET 2종 `p_plant_site_id` + GTT 단일지점 필터 + FE 81 전용 필드) | `sp/01·02` + `sql/03B`(재정렬) + `fe/` | (본 패키지가 원본) |
| ⑧ | ~2026-08-04 | MSG/LBL 신규 등록 증분 (0724 SYNC 이후 159행 — 전 화면 공통 포함) | `sql/07` | MSG_LBL_MNU_SYNC_20260724_1319 **선행** (0724까지분) |

**선행 패키지 (본 패키지 실행 전 클라우드 적용 확인)**
1. `MSG_LBL_MNU_SYNC_20260724_1319` — MSG/LBL/MNU 4분류 393 ID (0724까지)
2. `DMF0082_EXCHANGE_SAVE_20260724_1241` 의 `sp/` — **PKG_DMF0000** SPEC/BODY + GTT (환율 저장 SP. PREREQ=PKG_DMF0020 VALID)
3. 공용 SP/함수 존재 확인 — `90_VERIFY.sql` §9 (UF_FX_String_SplitForIN / DMF0073_GET_VERSION_SALESPRICE / DMF0002_GET_TITLESET_POPUP / SCM0000_GET_GRID_HEADER / PR_SCM_MST_EXCHANGE_RATE_UI 등)

---

## 2. 패키지 구성

```
DMF0082_20260804_1032/
├── sp/
│   ├── 00A_GTT_REBUILD_DMF0082.sql     ← (선택) 구판 GTT 구조 교정 시만 — DROP 후 00 재실행
│   ├── 00_GTT_DDL_DMF0082.sql          ← GTT 58종 자급 DDL (-955 skip 멱등) ⭐ Step 1 필수
│   ├── 01_PKG_DMF0082_SPEC.sql         ← 사내 live SPEC (GET 2종 p_plant_site_id DEFAULT 'ALL')
│   ├── 02_PKG_DMF0082_BODY.sql         ← 사내 live BODY (①②⑤⑥⑦ 누적 — 652KB)
│   └── 03_GRANT_SYNONYM.sql            ← SCMD_APP GRANT + SYNONYM
├── sql/
│   ├── 01_MNU_M.sql                    ← 메뉴 1행
│   ├── 02_API_BTN_AUTH.sql             ← API_M 15 + BTN_MPG 17 + USER_GR_MNU_MPG 6 + USER_GR_MNU_BTN_MPG 95
│   ├── 03A_PROC_M_INSERT.sql           ← PROC_M 비GET 58행 (INSERT-only)
│   ├── 03B_PROC_M_GET_REALIGN.sql      ← ⚠ GET 2종 38행 DELETE→INSERT (승인 게이트)
│   ├── 04_SHEET_COLUMNS_MEASURE.sql    ← SHEET_COLUMNS 69 + SHEET_MEASURE 14 (DIV82 포함 전 행)
│   ├── 05_CMBO_SQL.sql                 ← FE 소비 콤보 12종 (CLOB 분할)
│   ├── 06_LOOKUP_EDIT_POLICY.sql       ← 81/82 편집 정책 LOOKUP 5행 (작업계정 등록분)
│   └── 07_MSG_LBL_POST0724.sql         ← MSG_M 증분 159행 (0724 SYNC 이후)
├── fe/nscm-fe/features/demand/src/pages/forecast-price/   ← 26 파일 (2026-08-04 전체 스냅샷)
├── 90_VERIFY/90_VERIFY.sql             ← 적용 후 검증 (기대 카운트 = 사내 실측)
├── _COMMON_FILES_GUIDE.md              ← procedures.d.ts patch (공통 파일 — 패키지 미포함)
└── _README.md
```

## 3. 적용 순서 (클라우드)

1. **선행 확인** — §1 선행 패키지 3종 + `90_VERIFY.sql` §9 공용 객체 VALID
2. `sp/00_GTT_DDL_DMF0082.sql` (GTT 58종 — 구조 차이 의심 시에만 00A 선행 후 00)
3. `sp/01` SPEC → `sp/02` BODY → `sp/03` GRANT/SYNONYM → `90_VERIFY` §1~§3 (VALID·13 IN)
4. `sql/01 → 02 → 03A → 04 → 05 → 06 → 07` (전부 멱등 INSERT-only — 재실행 안전)
5. `sql/03B` — **90_VERIFY §4 로 클라우드 현행 PROC_M 확인 후 사용자 승인 하에 실행** (GET 2종 재정렬)
6. FE — ⭐ **파일 단위 덮어쓰기 금지** (클라우드 셸 신·구 세대 혼재): `forecast-price` **폴더 전체 삭제 후 통째 복사**
   `rm -rf nscm-fe/features/demand/src/pages/forecast-price && cp -r fe/nscm-fe/features/demand/src/pages/forecast-price nscm-fe/features/demand/src/pages/`
7. `_COMMON_FILES_GUIDE.md` patch (procedures.d.ts) → type-check → build (dev 포트 = 3000)
8. `90_VERIFY.sql` 전 항목 + 화면 smoke: div81 Plant Site 콤보 활성 → 조회 행수 감소 확인 / div40 무회귀 / 81 편집 저장

## 4. 발견 사항 (F)

- **F-1** `FcstPriceUserAuthGroup` 콤보 — FE(ForecastPrice.tsx L148) 소비 중이나 **사내에도 미등록**(실측 2026-08-04. 유사 등록: SalesPlanUserAuthGroup/BizPlanUserAuthGroup). 현재 authGroup='' → userId fallback 으로 동작(스토어 주석의 정상 fallback 경로). 등록 여부는 사용자 결정 대기 — 본 패키지는 사내와 동일 상태 유지.
- **F-2** `sql/06` LOOKUP 중 LAST_UPDATED_BY 만 작업계정인 행(기존 row 값 수정분)은 INSERT-only 로는 클라우드에 반영되지 않음 — 90_VERIFY 대조 후 차이 발견 시 목록 보고.
- **F-3** locale JSON(KO/EN/CN) = **이관 제외** (사용자 확정 2026-07-24 — FE 는 t() fallback 으로 동작).

## 5. 메타데이터

- 원천: 사내 Oracle OCGSCMD_P01 실측 덤프 (2026-08-04 10:32, 생성기 = scratchpad gen_dmf0082_pkg.py 패턴)
- PKG BODY LAST_DDL_TIME (사내): 2026-08-04 (Plant Site 적용 직후)
- 사내 smoke 실측: div81 'ALL'=413 / 'WA00-P'=242 / 'WA00-P,HQ07-A'=321 / div40=1,390 (20260701~0930)
- 룰: 22_PACKAGE_ARTIFACTS §9 (SP/메타 완전성) · deploy-package-gtt-type-ddl · deploy-package-msg-lbl-mnu-omission(INSERT-only) · cloud-shell-generation-mismatch(폴더 전체 교체)

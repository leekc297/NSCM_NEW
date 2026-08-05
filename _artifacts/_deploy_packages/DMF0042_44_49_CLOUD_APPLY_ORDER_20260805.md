# DMF0042 / DMF0044 / DMF0049 — 클라우드 이관 적용 순서서 (2026-08-05)

> 3개 UI 의 클라우드 미적용 누적분(PKG 취합 + 07-30 DB작업 + 메타 + FE)을 한 번에 이관하기 위한 순서서.
> 근거: 각 패키지 `_README.md` + 2026-08-05 diff 검증 (work_report `2026-08-05_DMF0042_44_49_잔여작업.md`).
> ⚠️ **클라우드 DB 적용물은 QA·DEV 2DB 동시 적용 의무** (feedback_cloud_be_build_out_of_sync_diagnosis §0).

---

## 0. 실행 금지 / 정본 확정 (2026-08-05 diff 검증)

| 항목 | 판정 |
|---|---|
| `DMF0044_0049_PKG_FIX_20260730/02_DB_SP/*` | ⛔ **실행 금지** — `DBWORK_7UI` BODY 가 superset (실행 시 07-30 후속 3작업 되돌림) |
| `DBWORK_7UI_.../02_DB_SP/10_PKG_DMF0044_BODY.sql` | ✅ 정본 — 2026-08-05 live 재동기화(07-31 `MAX(VERSION_TYPE)` 2건 포함) |
| `DBWORK_7UI_.../02_DB_SP/08·12` (0042/0049 BODY) | ✅ live 정합 실측 (LAST_DDL 07-30 22:38 / 22:07) |

## 1. 적용 순서 (DB — SCM_MGR / 마지막 SYNONYM 만 APP 계정)

| 순서 | 패키지 / 파일 | 비고 |
|---:|---|---|
| 0 | `DBWORK_7UI_.../00_PRECHECK/00_PRECHECK_CLOUD.sql` | ⭐ 게이트 3종. **PKG_DMF0044 BODY 사내 기준시각 = 07-31 10:39 로 판정** |
| 1 | `DBWORK_7UI_.../00_PRECHECK/01_BACKUP_CLOUD_CURRENT.sql` | 원복본 확보 |
| 2 | **클라우드 BE 정지** | library cache pin 방지. `ALTER SESSION SET DDL_LOCK_TIMEOUT=120` 권장 |
| 3 | `DMF0042_PKG_CONSOLIDATION_20260723` (5-Step: GTT DDL→SPEC→BODY→wiring→⚠ DROP 은 검증 후) | 3UI PKG 골격 선행 |
| 4 | `DMF0044_PKG_CONSOLIDATION_20260723` (동일 5-Step) | DMF0049 버튼 2개가 PKG_DMF0044 참조 — 0049 보다 먼저 |
| 5 | `DMF0049_PKG_CONSOLIDATION_20260723` (동일 5-Step) | PKG_DMF0049 본문이 `PKG_DMF0044.P_...` 내부 호출 |
| 6 | `DBWORK_7UI_...` Step 3~8 (TYPES→GTT→SPEC/BODY 01~16→17_GRANT→⛔18=APP 계정→03_META 01~04) | BODY 가 3~5 의 취합본을 **최종본으로 덮음** (정상 — live 스냅샷) |
| 7 | `DMF0042_COMBO_ASIS_ALIGN_20260723` → `DMF0044_...` → `DMF0049_...` | 콤보/조회조건 메타 |
| 8 | (승인 시) `_apply_corporate/DMF0042_TITLESET_MEASURE_DEPOLLUTE_20260805.sql` | titleset 오염 1행 DELETE — **사내·클라우드 공통 적용** |
| 9 | (승인 시) `_apply_corporate/DMF0042_TITLESET_GUARD_20260805_PKG_BODY.sql` | hook #115 가드 2줄 — 사내 선적용·검증 후 클라우드 |
| 10 | (승인 시) `_apply_corporate/DMF0044_MERGE_ON_KEYS_FIX_20260805_PKG_BODY.sql` | MERGE ON 3키 파리티 복원 — 사내 선적용·검증 후 클라우드 |
| 11 | 클라우드 BE 재기동 → `DBWORK_7UI_.../04_VERIFY/90_VERIFY_AFTER_APPLY.sql` | 기대값 대조 (PROC_M 211 / LBL 48 / NVL 센티널 136 등) |
| 12 | 화면 E2E (아래 §3) | 저장 SP 직접 실행 금지 (hook #104) |

### ⚠ 타 UI 오브젝트 staleness (본 순서서 범위 밖 — 적용 전 확인 필수)
`DBWORK_7UI` 는 7화면 스냅샷인데, 이후 사내 재배포된 오브젝트가 있다 (2026-08-05 LAST_DDL 실측):
- `PKG_DMF0003` BODY **08-04 17:18** / `PKG_DMF0021` BODY **08-04 19:42** / `PKG_DMF0082` SPEC·BODY **08-04** (+ `DBWORK_DMF0082_TUNING_20260731` / `DMF0082_20260804_1032` 별도 패키지 존재)
→ 이 3본은 `DBWORK_7UI` 판을 적용하면 **구본으로 회귀**한다. 해당 UI 의 최신 패키지 정합을 별도 확인한 뒤 최신본으로 마무리할 것 (3UI 순서서에서는 판단하지 않음).

## 2. FE 동시 이관 체크리스트 (DB 만 가면 LBL fallback / 팝업 미동작)

> 원칙: 파일 단위 덮어쓰기 금지 — **폴더 전체 checkout** (feedback_cloud_shell_generation_mismatch).

| # | 대상 | 비고 |
|---|---|---|
| F1 | `features/demand/src/components/versionModal/` 4파일 + `components/index.ts` | 공용 VersionModal (2026-08-05 `VersionMenuId` 리터럴 유니온 수정 포함) |
| F2 | `features/demand/src/pages/sales-reports/` 22파일 | `SalesReportsModals.tsx` import 정렬·미사용 제거(08-05) 포함 |
| F3 | `features/demand/src/pages/etc-sales-reports/` 20파일 | `EtcSalesReportsModals.tsx` 동일 |
| F4 | `features/demand/src/pages/business-plan/` 26파일 | |
| F5 | `configs/types/procedures.d.ts` | DMF0042/0044/0049/SCP0013 블록 포함본 |
| F6 | `public/locales/{KO,EN,CN}.json` | LBL00783·00794~800·00844~851 — **클라우드 FE 배포 경로로만 반영** (DB MSG_M 은 §1-6 의 03_META/04) |
| F7 | viewRegistry / route-paths / Router (배선 3점) | 'business-plan' / 'sales-reports' / 'etc-sales-reports' + SLUG_ALIAS |

검증: 클라우드 셸에서 `tsc --noEmit`(demand·web) 0 + eslint 0 → 화면 진입.

## 3. 적용 후 E2E 최소 세트

- DMF0042: 조회(81/82/40) → 편집 잠금 스팟 → ColumnSet/Measure 저장 → 재조회 (ORA-00960 재발 없음 확인)
- DMF0044: V1~V6 (United Version CREATE/COPY·Exchange·Textbox 82·저장 이원화 — R1 정정으로 부서명·팀명 실제값 표시 확인)
- DMF0049: V1~V5 (United 주입→조회→편집 매트릭스→세트 CRUD→저장 36키)

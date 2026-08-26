# DMF0035_CLOUD_20260820 — 파일 목록

> 총 **45 파일** (루트 4 + A_DB **18** + B_FE 22 + C_BE 1). 라인수는 실측(`Measure-Object -Line`).
> A_DB 는 번호순 적용. B_FE 는 폴더 단위 교체(부분 이관 금지). C_BE 는 배포물 없음(사유 문서만).
>
> ⭐ **2026-08-20 (2차) — `SCM_ADM_PROC_M` 축 누락 정정으로 A_DB 2파일 신설** (16 → 18):
> `19_PROC_DMF0073_VERSION_SALESPRICE.sql` · `24_PROC_M_SYNC.sql`.
> 동시에 `18_GRANT_SYNONYM.sql`(§5 DMF0073) · `90_VERIFY.sql`(V10) 수정. 상세 = `_README.md` §5.4·§5.5.

## 루트

| 파일 | 라인 | 바이트 | 설명 |
|---|---:|---:|---|
| `_README.md` | — | — | 적용 순서 / 축별 실측 카운트 / 판단 항목 / 미결 |
| `_FILELIST.md` | — | — | 본 파일 |
| `_generate_db_files.py` | 405 | 25,831 | A_DB 산출물 생성기 (사내 라이브 SELECT 전용 — 재현용) |
| `00_CLOUD_PRECHECK.sql` | 188 | 15,415 | 적용 **전** 점검 C1~C9 (SELECT 전용) |

## A_DB — 번호순 적용

| # | 파일 | 라인 | 바이트 | 내용 | 대상 행/객체 |
|---:|---|---:|---:|---|---|
| 01 | `A_DB/01_DDL_GTT.sql` | 1,002 | 56,763 | GTT 멱등 생성 (`-955` skip) | **49 GTT** |
| 02 | `A_DB/02_DDL_GTT_INDEX.sql` | 12 | 836 | GTT 인덱스 (`-955`/`-1408` skip) | **2 IDX** |
| 10 | `A_DB/10_PKG_SCM0002_SPEC.sql` | 252 | 9,612 | ⚠ 공유 PKG SPEC 원문 | PKG_SCM0002 |
| 11 | `A_DB/11_PKG_SCM0002_BODY.sql` | 3,920 | 209,858 | ⚠ 공유 PKG BODY **전체 원문** (부분 발췌 금지) | 사내 4,259 lines |
| 12 | `A_DB/12_PKG_DMF0035_SPEC.sql` | 57 | 3,275 | SPEC 원문 | PKG_DMF0035 |
| 13 | `A_DB/13_PKG_DMF0035_BODY.sql` | 4,178 | 262,741 | ⭐ **WFITEMPERF + DS2 + VERPUSH(2차 튜닝) 포함** BODY 원문 | 사내 4,166 lines / `E20260820-VERPUSH` × **6** |
| 14 | `A_DB/14_PKG_DMF0022_SPEC.sql` | 60 | 3,324 | SPEC 원문 | PKG_DMF0022 |
| 15 | `A_DB/15_PKG_DMF0022_BODY.sql` | 3,450 | 234,326 | ⭐ **08-06 정본 재적용분** BODY 원문 | 사내 3,668 lines |
| 16 | `A_DB/16_PKG_DMF0051_SPEC.sql` | 56 | 2,667 | SPEC 원문 | PKG_DMF0051 |
| 17 | `A_DB/17_PKG_DMF0051_BODY.sql` | 1,671 | 103,854 | BODY 원문 | 사내 1,760 lines |
| 18 | `A_DB/18_GRANT_SYNONYM.sql` | 80 | 6,097 | EXECUTE GRANT + SYNONYM (DBA 문안) ⭐ **§5 DMF0073 추가** | GRANT **10** / SYN **10** |
| 19 | `A_DB/19_PROC_DMF0073_VERSION_SALESPRICE.sql` | 121 | 6,459 | ⭐ **신설** — standalone PROCEDURE 라이브 원문. **클라우드 결손 시에만 적용** | 사내 119 lines / VALID |
| 20 | `A_DB/20_MENU_META_SYNC.sql` | 328 | 50,726 | 메뉴·프로그램·API·버튼·권한 MERGE | **63행** (1+1+8+8+5+40) |
| 21 | `A_DB/21_CMBO_SYNC.sql` | 52 | 14,745 | CMBO MERGE (⚠ 5본 공유) | **7행** |
| 22 | `A_DB/22_SHEET_META_SYNC.sql` | 986 | 433,301 | 시트 메타 SHEET_NAME 단위 재적재 | **482행** (309 + 173) |
| 23 | `A_DB/23_MSG_LBL_MNU_SYNC.sql` | 336 | 51,476 | MSG/LBL/MNU MERGE | **66행** (22코드 × 3언어) |
| 24 | `A_DB/24_PROC_M_SYNC.sql` | 459 | 59,165 | ⭐ **신설** — `SCM_ADM_PROC_M` MERGE (PLS-00306 정정). ON 키 = 실측 PK `(PROC_NM, COL_NM, COL_TP_CD)` | **80행** (25+7+9+22+9+8) |
| 90 | `A_DB/90_VERIFY.sql` | 228 | 17,441 | 적용 **후** 검증 V1~V8 + ⭐**V10 배선 역추적(0행)** + V9 스모크 | — |

### A_DB 메타 적재 총계
`20`(63) + `21`(7) + `22`(482) + `23`(66) + ⭐`24`(**80**) = **698행**
+ DDL 51객체(GTT 49 + IDX 2) + PKG 8객체 + ⭐PROCEDURE 1객체(`19`, 결손 시) + 권한 **20**(GRANT 10 + SYN 10).

## B_FE

### 화면 폴더 전체 (12파일) → `nscm-fe/features/report/src/pages/demand-plan-waterfall/`

| 파일 | 라인 | 바이트 |
|---|---:|---:|
| `B_FE/demand-plan-waterfall/index.ts` | 1 | 39 |
| `B_FE/demand-plan-waterfall/DemandPlanWaterfall.tsx` | 188 | 8,227 |
| `B_FE/demand-plan-waterfall/demand-plan-waterfall.constants.ts` | 87 | 3,749 |
| `B_FE/demand-plan-waterfall/demand-plan-waterfall.types.ts` | 41 | 1,666 |
| `B_FE/demand-plan-waterfall/useDemandPlanWaterfallStore.ts` | 206 | 7,542 |
| `B_FE/demand-plan-waterfall/__asis-mapping__.md` | 60 | 5,606 |
| `B_FE/demand-plan-waterfall/components/DemandPlanWaterfallForm.tsx` | 434 | 18,310 |
| `B_FE/demand-plan-waterfall/components/DemandPlanWaterfallForm.module.scss` | 15 | 237 |
| `B_FE/demand-plan-waterfall/components/DemandPlanWaterfallGrid.tsx` | 214 | 8,919 |
| `B_FE/demand-plan-waterfall/components/OlapLayoutModal.tsx` | 107 | 4,013 |
| `B_FE/demand-plan-waterfall/components/WaterfallVersionModal.tsx` | 301 | 11,801 |
| `B_FE/demand-plan-waterfall/components/WaterfallVersionModal.module.scss` | 29 | 551 |

> ⚠ `index.ts` 는 `viewRegistry` glob(`features/*/src/pages/*/index.ts`)의 **유일한 등록 키**다.
> 빠지면 탭 안에서 `resolveView()` 실패 → "Page Not Found"(라우터 404 아님). **폴더 전체 이관**.

### 공용 (⚠ 타 화면 영향) → 각 원위치

| 파일 | 라인 | 바이트 | 배치 경로 |
|---|---:|---:|---|
| `B_FE/shared-olap-pivot-grid/OlapPivotGrid.tsx` | 227 | 10,551 | `nscm-fe/packages/shared/src/components/organisms/olap-pivot-grid/OlapPivotGrid.tsx` ⭐ `autoFitColumns` 신설 |
| `B_FE/shared-olap-pivot-grid/olapUtils.ts` | 34 | 1,325 | `nscm-fe/packages/shared/src/components/organisms/olap-pivot-grid/olapUtils.ts` |
| `B_FE/shared-olap-pivot-grid/organisms-index.ts` | 12 | 514 | `nscm-fe/packages/shared/src/components/organisms/index.ts` (olap 2줄 export 추가분) |
| `B_FE/configs-types/procedures.d.ts` | 4,273 | 140,952 | `nscm-fe/configs/types/procedures.d.ts` (DMF0035 블록 L157~) |

### 참고 자료 (직접 배포물 아님)

| 파일 | 라인 | 용도 |
|---|---:|---|
| `B_FE/locales/KO.json` | 24 | DMF0035 소비 22키 발췌 — **정본은 DB `SCM_ADM_MSG_M`**(`A_DB/23`). FE locales 는 `pnpm gen:i18n` 이 BE `/admin/message` 에서 재생성 |
| `B_FE/locales/EN.json` | 24 | 동일 |
| `B_FE/locales/CN.json` | 24 | 동일 |
| `B_FE/feature-report-scaffold/package.json` | 26 | `@report` 워크스페이스 **미존재 시에만** 사용 (§README 4.3) |
| `B_FE/feature-report-scaffold/tsconfig.json` | 10 | 동일 |
| `B_FE/feature-report-scaffold/src/index.ts` | 2 | 동일 — ⚠ `sales-plan-waterfall` 도 export 하므로 그 폴더 없으면 빌드 실패 |

## C_BE

| 파일 | 라인 | 내용 |
|---|---:|---|
| `C_BE/_NO_BE_CHANGE.md` | 31 | **BE 변경 0건** — git log/status/소스 grep 3축 실측 근거 |

## 배포물이 아닌 것 (제외 명시)

| 축 | 사유 |
|---|---|
| `SCM_MST_TITLESET_USER` (607행) | 사용자 개인화 — 이관 제외 |
| `SCM_ADM_LOOKUP_MASTER_DETAIL` (21 type / 675행) | 공유 마스터 — PRECHECK C5 로 결손 탐지만 |
| ~~`DMF0073_GET_VERSION_SALESPRICE`~~ | ⭐ **제외 취소 (2026-08-20 격상)** — 클라우드 **결손 확인됨**(PROC_M 9행 O / 객체 부재 ARG_CNT 0). 본문 `A_DB/19` + GRANT·시노님 `A_DB/18` §5 로 **동봉함**. §README 5.4 |
| `SCM_ADM_PROC_M` / `PKG_DMF0022.P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL` (25행) | ⚠ **공유 축 — 클라우드 정상 등재(25/25). DMF0022 소관이므로 덮어쓰면 회귀** → `A_DB/24` 에 의도적 미포함 |
| `SCM_ADM_PROC_M` / `DMF0073_GET_VERSION_SALESPRICE` (9행) | 클라우드 메타 9행 정상 — 결손은 객체 쪽이므로 메타 재적재 불필요 |
| `DMF0073_SAVE_VERSION_SALESPRICE` | 사내에서 `STATUS=INVALID`. 조회 전용 화면이라 미소비 — 이관 대상 아님 |
| `nscm-be` MenuController/Service/ServiceImpl/Menu.xml | DMF0082 titleset 복원분 — `DMF0082_CLOUD_20260820/C_BE` 소관 |

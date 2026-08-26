# DMF0082 (Forecast & Price) 클라우드 이관 — 전 축 취합 **정본** (2026-08-23)

> **상태: 취합 완료 / 클라우드 미적용.** 사내 기준 2026-08-23 (PKG_DMF0082 PACKAGE·BODY VALID).
> ⭐ 본 폴더가 **DMF0082 이관 정본**이다. `DMF0082_CLOUD_20260823`(선행 수작업+생성기 판)은 **superseded**.
> 선행 계보 `_20260808_1830` / `_20260812` / `_20260814` / `_20260818` / `_20260820` 전부 흡수.

## 0. 이번 판이 선행판과 다른 점 (왜 다시 떴나)

| # | 항목 | 내용 |
|---|---|---|
| 1 | **기계 전수 스윕으로 재도출** | `make_cloud_package_full.py --menu DMF0082` (A축 18표 / B축 37객체 / MSG 합집합). 선행판의 6개 메타 파일과 **행수가 1:1 일치**(90 / 22 / 1 / 266 / 21 / 227)함을 확인 — 선행 취합이 옳았다는 교차검증이다 |
| 2 | **PROGRAM 패밀리 스코프** | `DMF0074_40` 류 division 변형을 놓치던 스코프 결함을 생성기에서 고쳤다. **DMF0082 는 변형 없음**(전 축 `DMF0082` 단일)을 실측 확인 |
| 3 | **감사컬럼 정규화** | 메타 SQL 의 `CREATED_BY`/`LAST_UPDATED_BY` 개인 ID(`minyonglee1`) → `'admin'`. `'system'` 유래는 보존 |
| 4 | ⭐ **90_VERIFY V2 오탐 정정** | 종전 V2 는 줄당 '첫 마커'만 귀속시켜 한 줄에 마커 2개인 3줄을 놓쳤다 → `E20260820-XLSWEEKLY` 를 **11**로 오집계(실제 14). 마커별 `INSTR` 직접 집계로 교체. **사내 실행 결과 15개 마커 전부 PASS** |

## 1. 이관 대상 (기계 스윕 + 사내 실측, 전 항목 사내 PASS)

| 축 | 대상 | 실측 | 파일 | 방식 |
|---|---|---:|---|---|
| GTT | `GT_DMF0082_*` 33종 + `IX_GT_DMF0082_PARAM_TOKEN_01` | 34 | `A_DB/00_GTT_DDL.sql` | 기존재 skip · 멱등 |
| DDL | `DEFAULT ON NULL` 5표 (12/12/13/11/13) | 61열 | `A_DB/00B_DDL_DEFAULT_ON_NULL.sql` | 멱등 |
| DB 객체 | `PKG_DMF0082` SPEC / BODY | 92 / 14,753줄 | `A_DB/01_…SPEC.sql` · `02_…BODY.sql` | 전체 교체 |
| 콤보 | `SCM_ADM_CMBO_SQL_M` | 24행 | `A_DB/04_CMBO_SYNC.sql` | MERGE (⚠ 공유 콤보 포함 — §3) |
| 메타 | `SCM_MST_SHEET_COLUMNS` (FcstNPrice 65 + Sales Price Save All 25) | 90행 | `A_DB/10_SHEET_COLUMNS.sql` | 시트 단위 삭제 후 재적재 |
| 메타 | `SCM_MST_SHEET_MEASURE` | 22행 | `A_DB/11_SHEET_MEASURE.sql` | 범위 삭제 후 재적재 |
| 메타 | `SCM_ADM_EXCEL_COLUMNS` | 1행 | `A_DB/12_EXCEL_COLUMNS.sql` | 범위 삭제 후 재적재 |
| 배선 | `PROGRAM` 1 · `MNU_M` 1 · `API_M` 17 · `PROC_M` 123 · `BTN_MPG` 18 | 160행 | `A_DB/20_WIRING_AUTH.sql` | MERGE (PK 실측) |
| 권한 | `USER_GR_MNU` 6 · `USER_GR_BTN` 100 | 106행 | `A_DB/20_WIRING_AUTH.sql` | MERGE ⚠ 그룹 실존 확인 (PRECHECK C7) |
| LOOKUP | `SCM_ADM_LOOKUP_MASTER_DETAIL` | 21행 | `A_DB/21_LOOKUP.sql` | MERGE (PK=SEG1~5, NULL-safe) |
| MSG/LBL/MNU | 92코드 → 227행 | 227행 | `A_DB/30_MSG_LBL_MNU.sql` | **INSERT-only (NOT EXISTS)** |
| FE | 재판정 후 **14** (+ 병합 5) | **14** | `B_FE/**` | 경로 그대로 (§FE 이관 경로 상세) |
| BE | admin-menu 4본 | 4 | `C_BE/**` | 파일 교체 (§BE 이관 경로) |

## 2. 담긴 정정 (BODY 마커 — 사내 실측 = 기대값)

`E20260818-PRICECHK1`(1) · `-UPLOADBATCH`(1) · `E20260819-LIMITMEAS`(5) · `-MULTIJOIN`(10) · `-PJTNAME`(4) ·
`-SENDERJOIN`(5) · `-XLS81LOC`(16) · `E20260820-AFSNULL`(11) · `-MEASRULE`(1) · `-SENTINELDDL`(12) ·
`-XLSSAVEPERF`(2) · `-XLSWEEKLY`(**14**) · `E20260822-DIV81DEL`(2) · `-KEYCOL`(2) · `-LOCWEEKSUM`(1)

직전 패키지 `_20260820` 대비 BODY delta **+149행** = 2026-08-22 정정 3건(DIV81DEL / KEYCOL / LOCWEEKSUM).
마커 없는 08-22 정정 2건은 `90_VERIFY V3` 가 본문 실측으로 잡는다.

## 3. 이관 제외 / 주의 (사유 명시)

| 대상 | 실측 | 사유 |
|---|---:|---|
| `SCM_MST_TITLESET_USER` | 355행 | **사용자 개인화** — 이관 제외 (hook 실측 규약) |
| `SCM_ADM_EXCEL_UPLOAD` | 163행 | 엑셀 업로드 **스테이징 실행 데이터** |
| `SCM_ADM_LOOKUP_MASTER_DETAIL_H` | 1행 | **이력 테이블** |
| `SCM_MST_SHEET_COLUMNS_0408` / `_260408` | 69 / 69 | **백업 테이블** |
| `DROP_RUN_DMF0082_SAVE_MAIN_DATA` | 0행 | 실험 잔재 테이블 |
| 공용 GTT (`GT_PRDM*` · `GT_DMF0003_*` · `GT_DMF0_TITLEO`) | — | **타 패키지 소관** — 본 패키지가 만들지 않는다. PRECHECK C2 로 **존재만** 확인 |
| ⚠ `04_CMBO_SYNC.sql` 24종 | 24 | DMF0082 전용은 6종뿐이고 나머지는 **타 화면과 공유**. 덮어쓰기 부작용을 감수하고 동봉한 판이다 — 클라우드가 이미 최신이면 **선별 적용**할 것 (C6 로 LUD 비교) |

<!-- FE-PATHMAP -->
## FE 이관 경로 상세 — **최신 공통소스 기준 재판정본 (2026-08-24)**

> 배포 루트 = `nscm-fe`. `B_FE/` 아래 경로가 곧 배포 경로다.
> ⭐ 2026-08-24 에 최신 공통소스(`common` HEAD `badd49a0`)를 직접 받아 **96본을 전수 재판정**했다.
> 종전 판정은 2026-08-23 에 내려받은 낡은 기준선(`90f975db`)을 썼고, 그 때문에 클라우드가 두 번 깨졌다.

| 판정 | 본수 | 처리 |
|---|---:|---|
| 공통 최신과 **바이트 동일** | **77** | **이관 불필요 — 제외** |
| 화면 폴더(우리 소유) + 공용 상위집합 | **14** | `B_FE/` — 그대로 덮는다 |
| 공통에만 있는 코드 보유 | **5** | `B_FE_MERGE/` — ⛔ **병합**(덮기 금지) |

### ① 화면 폴더 — **폴더 통째** (`index.ts` 가 viewRegistry 등록 키)

| 패키지 내 위치 | **이관 대상 경로 (배포 루트 기준)** | 파일 | 파일명 |
|---|---|---:|---|
| `B_FE/features/demand/src/pages/forecast-price` | **`nscm-fe/features/demand/src/pages/forecast-price`** | 3 | `ForecastPrice.tsx`, `__asis-mapping__.md`, `forecast-price.constants.ts` |
| `B_FE/features/demand/src/pages/forecast-price/components` | **`nscm-fe/features/demand/src/pages/forecast-price/components`** | 2 | `ForecastPriceForm.tsx`, `ForecastPriceGrid.tsx` |
| `B_FE/features/demand/src/pages/forecast-price/components/modals` | **`nscm-fe/features/demand/src/pages/forecast-price/components/modals`** | 2 | `ForecastTemplateModal.tsx`, `SavePricePeriodModal.tsx` |
| `B_FE/features/demand/src/pages/forecast-price/utils` | **`nscm-fe/features/demand/src/pages/forecast-price/utils`** | 2 | `forecast-price.combo.ts`, `forecast-price.groupMeasure.test.ts` |

### ② 공용 — 화면이 실제로 닿는 **변경분 폐포**(기계 산출). 미변경 공용은 클라우드 것을 그대로 둔다

| 패키지 내 위치 | **이관 대상 경로 (배포 루트 기준)** | 파일 | 파일명 |
|---|---|---:|---|
| `B_FE/packages/foundation/src/utils` | **`nscm-fe/packages/foundation/src/utils`** | 1 | `string.ts` |
| `B_FE/packages/shared/src/components/organisms` | **`nscm-fe/packages/shared/src/components/organisms`** | 1 | `index.ts` |
| `B_FE/packages/shared/src/components/organisms/olap-pivot-grid` | **`nscm-fe/packages/shared/src/components/organisms/olap-pivot-grid`** | 2 | `OlapPivotGrid.tsx`, `olapUtils.ts` |
| `B_FE/packages/shared/src/components/templates/modals/column-layout-modal` | **`nscm-fe/packages/shared/src/components/templates/modals/column-layout-modal`** | 1 | `columnLayoutModal.utils.ts` |


> `B_FE_MERGE/` 5본은 각각 `*.COMMON.txt`(공통 최신 원본)를 함께 넣었다. 절차 = `B_FE_MERGE/_READ_FIRST.md`.
> 특히 `configs/types/procedures.d.ts` 는 통째로 덮으면 **타 화면 계약 547줄이 날아간다**.


### 🔁 `B_FE_POOL/` — 클라우드가 뒤처졌을 때만 쓰는 예비분 (2026-08-24 신설)

**클라우드 트리는 사내와도, 공통소스와도 다르다.** 실사고 3연발이 그걸 증명했다.

| 방향 | 실사고 | 증상 |
|---|---|---|
| 클라우드가 **앞섬** | `CascadeFields` / `useCascadeFields` (클라우드에만) | 우리 것으로 덮어 **TS2305** ×2 |
| 클라우드가 **뒤처짐** | `CELL_CONTROL_TYPE.TEXT_MODAL` (공통엔 있는데 클라우드엔 없음) | **TS2339** |

그래서 "무엇을 올릴지"는 사내에서 다 정할 수 없다 — **클라우드에서 판정해야** 한 번에 끝난다.

- `B_FE/` … 반드시 덮는다 (우리가 앞서거나 클라우드에 없는 신규)
- `B_FE_POOL/` … 사내 = 공통소스가 **완전히 같은** 파일들. 클라우드가 최신이면 **아무것도 안 올린다**
- `B_FE_MERGE/` … ⛔ 덮기 금지, 병합

```
# 배포 루트(nscm-fe) 에서
node <이 폴더>/_cloud_gap_check.mjs <이 폴더>/B_FE_POOL           # 진단만 (SAME / STALE / MISSING)
node <이 폴더>/_cloud_gap_check.mjs <이 폴더>/B_FE_POOL --apply   # 다른 것만 실제 복사
```

`STALE`/`MISSING` 로 잡힌 것만 최신화되므로 클라우드 고유 작업을 덮지 않는다.
이번 `TEXT_MODAL`(TS2339) 도 `packages/foundation/src/constants/column-config.ts` 가
`STALE` 로 잡혀 한 번에 해소된다.

**권장 순서**: ① `_precopy_export_guard.mjs` → ② `B_FE/` 덮기 → ③ `_cloud_gap_check.mjs --apply`
→ ④ `B_FE_MERGE/` 병합 → ⑤ `pnpm exec turbo run type-check --continue`

<!-- /FE-PATHMAP -->

### 클라우드 `pnpm run lint` error 6건 — 본 패키지가 해소한다 (2026-08-23 사용자 제보)

클라우드에서 난 **error 는 전부 `forecast-price`(DMF0082) 파일**이고, 우리 트리에서는 이미 정정되어 있다.
클라우드 사본이 **정정 이전 세대**라서 나는 것이다. 아래 5개 파일은 패키지 사본과 사내 트리가 **md5 동일** 확인.

| # | 클라우드 오류 위치 | 규칙 | 정정 내용 | 동봉 파일 |
|---:|---|---|---|---|
| 1 | `ForecastPrice.tsx:300` | `no-base-to-string` | 행 배열을 `WijmoRowItem[]`(원시 타입 유니온)으로 좁혀 `String()` 안전화 | `B_FE/features/demand/src/pages/forecast-price/ForecastPrice.tsx` |
| 2 | `ForecastPriceGrid.tsx:271` | `no-unnecessary-type-assertion` | 불필요 단언 제거(`?? ''` + `as const` 튜플로 정리) | `.../components/ForecastPriceGrid.tsx` |
| 3 | `SavePricePeriodModal.tsx:69` | `no-base-to-string` | `String(v)` → **`safeString(v)`**(`@foundation/utils`) | `.../components/modals/SavePricePeriodModal.tsx` |
| 4 | `SavePricePeriodModal.tsx:336` | `no-multiple-empty-lines` | 빈 줄 정리 | 〃 |
| 5 | `forecast-price.api.ts:105` | `no-base-to-string` | `WEEK_LIST` 를 `string\|number` 로 좁힌 뒤 변환 | `.../utils/forecast-price.api.ts` |
| 6 | `forecast-price.excelForm.ts:3` | `no-unused-imports` | 미사용 `UPLOAD_HEADERS` import 제거 | `.../utils/forecast-price.excelForm.ts` |

⭐ 3번은 **`safeString` 이 있어야** 성립한다 — 기준선 `@foundation/utils` 에 없는 신규 export 라
`B_FE/packages/foundation/src/utils/string.ts` 를 **반드시 같이** 올려야 한다(안 올리면 TS2305 로 더 크게 깨진다).

✅ **전체 로그 확인 완료(2026-08-23).** 클라우드 `@demand` = `✖ 68 problems (6 errors, 62 warnings)` 이고
**error 6건은 전부 위 표의 `forecast-price` 건**이다. 나머지 11개 패키지는 전부 `0 errors`
(`@foundation` 6 / `@master` 49 / `@admin` 28 / `@web` 10 / `@shared` 17 / `@spms-demand` 5 warning,
`@authority`·`@supply`·`@shipping`·`@factory`·`@report` 무출력). 즉 **이 패키지 하나로 클라우드 lint 가 통과**한다.

사내 대조는 캐시가 아니라 강제 재실행으로 확인했다 — `TURBO_FORCE=true`, `Cached: 0 cached, 1 total`,
결과 `@demand ✖ 61 problems (0 errors, 61 warnings)`. 원문 = `_survey/fe_check_20260823.txt`.

⚠ 이전 메모(로그 절단)는 해소되었다.


## BE 이관 경로 (파일 단위)

> 배포 루트 = `nscm-be`.

| 패키지 내 파일 | **이관 대상 경로** |
|---|---|
| `C_BE/admin-menu/MenuController.java` | **`nscm-be/src/main/java/com/lgcns/nscm/admin/menu/MenuController.java`** |
| `C_BE/admin-menu/MenuService.java` | **`nscm-be/src/main/java/com/lgcns/nscm/admin/menu/MenuService.java`** |
| `C_BE/admin-menu/MenuServiceImpl.java` | **`nscm-be/src/main/java/com/lgcns/nscm/admin/menu/MenuServiceImpl.java`** |
| `C_BE/admin-menu/Menu.xml` | **`nscm-be/src/main/resources/sql/admin/Menu.xml`** ⚠ `bin/main/...` 은 빌드 산출물이니 건드리지 말 것 |

4본 모두 현재 사내 소스와 **동일**(diff 0). 적용 후 **BE 재기동** 필요.

## FE 검증 (이관 취합의 일부 — 2026-08-23)

넥서스 미접속 로컬 검증(`_artifacts/_tools/fe-check.ps1`, 고정 pnpm 10.28.2)을 **패키지 취합 시점에** 돌렸다.

| 항목 | 결과 |
|---|---|
| `type-check` | **13/13 성공 · error 0** |
| `lint` | **13/13 성공 · error 0** (warning 193 — `import/no-relative-parent-imports` 등 기존분) |

원문 = `_survey/fe_check_20260823.txt`.
⚠ 이 검증은 **우리 작업 트리 기준**이다. 클라우드는 공용 세대가 달라, 위 §FE 이관 경로의 공용 폐포를 **함께** 올린 뒤
클라우드에서 `type-check` 를 한 번 더 돌려야 한다(TS2305/TS2322 는 그때만 드러난다).


## 4. 적용 순서

1. `00_CLOUD_PRECHECK.sql` (QA·DEV 각각) — **C4 가 ⛔ 적용 게이트**(원장 `PLANT_SITE_ID` 센티널 변형).
   C1 로 클라우드 BODY 세대 판정, C2 GTT, C6 공유 CMBO LUD, C7 권한그룹, C9 MSG 코드 충돌
2. `A_DB/00_GTT_DDL.sql` → `00B_DDL_DEFAULT_ON_NULL.sql`
3. `A_DB/01_PKG_DMF0082_SPEC.sql` → `02_PKG_DMF0082_BODY.sql`
4. `A_DB/04_CMBO_SYNC.sql`(선별) → `10` → `11` → `12` → `20` → `21` → `30`
5. `C_BE/**` 배포 후 BE 재기동 → `B_FE/**` 배포
6. `A_DB/90_VERIFY.sql` (기대: V1~V9 전부 PASS / V9 는 0행) → V10 화면 스모크

## 5. 미해결 — 적용해도 남는 것

- 81 Excel **필수컬럼** 축 미착수 · V81-04 성능 패치 대기 (`project_dmf0082_session_20260820` 계보)
- 공유 CMBO 12종의 클라우드 최신성은 **확인 필요**(C6). 무조건 덮으면 타 화면 회귀 위험
- 본 패키지는 **클라우드 미적용**이다. 적용 후 `90_VERIFY` 결과를 보존할 것

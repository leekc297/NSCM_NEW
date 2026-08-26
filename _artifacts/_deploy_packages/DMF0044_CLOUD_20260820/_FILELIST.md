# DMF0044_CLOUD_20260820 — 파일 목록

총 **58 파일**. 행수는 실측(2026-08-21).
상세 배경·판단 항목은 `_README.md` 참조.

---

## A_DB (12본) — 적용 순서 = 파일명 번호순

| # | 파일 | 행 | 내용 | 실행 계정 |
|---|---|---:|---|---|
| 0 | `00_CLOUD_PRECHECK.sql` | 146 | ⭐ 클라우드 **사전** 확인 C1~C8 (객체상태 / GTT 구조 / 메타 카운트 / 공유콤보 diff / 공유시트 분해 / PROC_M 공유3본 / GRANT·SYNONYM / PREREQ 12객체). READ ONLY | SCM_MGR |
| 1 | `01_DDL_GTT.sql` | 412 | GTT **18본** 멱등 생성 (`-955` skip). 축 = 소스 grep(LIVE) ∩ `ALL_DEPENDENCIES` 완전 일치 | SCM_MGR |
| 2 | `02_DDL_GTT_INDEX.sql` | 4 | ⚠ **0행 축** — 본 화면 GTT 에 인덱스 없음(명기용) | SCM_MGR |
| 3 | `10_PKG_DMF0044_SPEC.sql` | 59 | `PKG_DMF0044` PACKAGE — 라이브 `ALL_SOURCE` 원문 | SCM_MGR |
| 4 | `11_PKG_DMF0044_BODY.sql` | 9,373 | `PKG_DMF0044` BODY — 라이브 원문. 2026-08-20 마커 4계열 9건 포함 | SCM_MGR |
| 5 | `18_GRANT_SYNONYM.sql` | 54 | `PKG_DMF0044` EXECUTE GRANT 2 + 시노님 2. 공유객체 3본은 조건부(주석) | GRANT=SCM_MGR / SYN=DBA |
| 6 | `20_MENU_META_SYNC.sql` | 717 | MNU_M 1 / PROGRAM 1 / API_M 28 / MNU_BTN_MPG_M 29 / USER_GR_MNU_MPG_M 3 / USER_GR_MNU_BTN_MPG_M 77 = **139 MERGE** | SCM_MGR |
| 7 | `21_CMBO_SYNC.sql` | 148 | `SCM_ADM_CMBO_SQL_M` **23종** MERGE (FE grep 8 + 시트메타 15 합집합) | SCM_MGR |
| 8 | `22_SHEET_META_SYNC.sql` | 291 | SHEET_COLUMNS 3시트 **114행** + SHEET_MEASURE 1시트 **21행** — SHEET_NAME 단위 DELETE→INSERT | SCM_MGR |
| 9 | `23_MSG_LBL_MNU_SYNC.sql` | 518 | `SCM_ADM_MSG_M` **34코드 × 3언어 = 102행** MERGE | SCM_MGR |
| 10 | `24_PROC_M_SYNC.sql` | 940 | ⭐ `SCM_ADM_PROC_M` §1 본화면 **151행**(15 SP, 항상) + §2 공유 **29행**(3객체, 조건부·주석) | SCM_MGR |
| 11 | `25_EXCEL_COLUMNS_SYNC.sql` | 9 | ⚠ **0행 축** — `SCM_ADM_EXCEL_COLUMNS` 미보유(명기용) | — |
| 12 | `90_VERIFY.sql` | 267 | 적용 후 검증 V1~V8 (18 statement). 사내 실행 결과 **FAIL 0 / WARN 1** | SCM_MGR |

---

## B_FE (34본) — `nscm-fe/` 기준 **원래 상대경로 그대로** 복사

### ① 페이지 폴더 전체 (22본 / 3,829행) — `features/demand/src/pages/sales-reports/`

| 파일 | 행 |
|---|---:|
| `index.ts` | 1 |
| `SalesReports.tsx` | 471 |
| `SalesReports.module.scss` | 128 |
| `sales-reports.constants.ts` | 97 |
| `sales-reports.types.ts` | 40 |
| `useSalesReportsStore.ts` | 249 |
| `__asis-mapping__.md` | 332 |
| `components/SalesReportsForm.tsx` | 142 |
| `components/SalesReportsForm.module.scss` | 167 |
| `components/SalesReportsGrid.tsx` | 591 |
| `components/SalesReportsModals.tsx` | 220 |
| `components/modals/index.ts` | 2 |
| `components/modals/ExchangeRateModal.tsx` | 776 |
| `components/modals/ExchangeRateModal.module.scss` | 37 |
| `components/modals/TextboxModal.tsx` | 188 |
| `utils/sales-reports.api.ts` | 87 |
| `utils/sales-reports.division.ts` | 6 |
| `utils/sales-reports.editLock.ts` | 93 |
| `utils/sales-reports.gridCombos.ts` | 80 |
| `utils/sales-reports.merge.ts` | 78 |
| `utils/sales-reports.save.ts` | 224 |
| `utils/sales-reports.validate.ts` | 18 |

> ⚠ **폴더 전체가 이관 단위**다. `index.ts` 가 `viewRegistry` glob 의 **유일한 등록 키**라
> 부분 이관하면 탭 안에서 `resolveView()` 가 실패해 "Page Not Found" 가 된다(2026-08-14 계보).
> 생성기가 `index.ts` 존재를 assert 한다.

### ② out-of-page 폐포 (8본 / 2,040행)

| 파일 | 행 | 폐포 근거 |
|---|---:|---|
| `features/master/src/components/searchFields/SearchFields.tsx` | 872 | `DivisionField` / `VersionField` 원천 |
| `features/master/src/components/columnLayoutModal/ColumnLayoutModal.tsx` | 8 | master 배럴 re-export (2026-08-20 정본 단일화 스텁) |
| `features/master/src/components/columnLayoutModal/columnLayoutModal.utils.ts` | 21 | 동 배럴 폐포 |
| `packages/foundation/src/utils/mergeManager.ts` | 215 | `@foundation/utils` 배럴 폐포 (`allowEmptyCellMerge` 확장점) |
| `packages/shared/src/components/molecules/customDropdown/CustomDropdown.tsx` | 263 | `@shared/components` — Form·환율모달의 CustomDropdown |
| `packages/shared/src/components/templates/modals/column-layout-modal/ColumnLayoutModal.tsx` | 422 | `@shared/components` — Column 모달 **정본** |
| `packages/shared/src/components/organisms/index.ts` | 12 | `@shared/components` organisms 배럴 |
| `packages/shared/src/components/organisms/olap-pivot-grid/OlapPivotGrid.tsx` | 227 | 위 배럴이 re-export |

### ③ 타입 (1본)

| 파일 | 행 |
|---|---:|
| `configs/types/procedures.d.ts` | 4,273 |

### ④ locales 발췌 (3본) — `public/locales/`

| 파일 | 코드 | 원본 전체 키 |
|---|---:|---:|
| `KO.json` | 34/34 | 914 |
| `EN.json` | 34/34 | 858 |
| `CN.json` | 34/34 | 852 |

> 발췌 축 = A_DB/23 과 동일한 34코드. **결손 0** (3언어 전부 확보).
> ⚠ 클라우드 반영은 **머지**로 할 것 — 발췌 파일로 통째 덮어쓰면 나머지 800+ 키가 전멸한다
> (hook `sync_i18n_mock_wipe` 계보).

---

## C_BE (6본 / 467행) — `nscm-be/` 기준 원래 상대경로

| 파일 | 행 | 내용 |
|---|---:|---|
| `src/main/java/com/lgcns/nscm/admin/menu/MenuController.java` | 146 | `POST /admin/menu/{mnuId}/titleset/search` · `POST /admin/menu/{mnuId}/titleset` 2본 추가 |
| `src/main/java/com/lgcns/nscm/admin/menu/MenuService.java` | 21 | 인터페이스 시그니처 2본 |
| `src/main/java/com/lgcns/nscm/admin/menu/MenuServiceImpl.java` | 150 | 구현 |
| `src/main/resources/sql/admin/Menu.xml` | 93 | MyBatis 매퍼 |
| `src/main/java/com/lgcns/nscm/admin/menu/dto/TitleSetSearchRequest.java` | 22 | (기커밋 — 자급용 동봉) |
| `src/main/java/com/lgcns/nscm/admin/menu/dto/TitleSetSaveRequest.java` | 35 | (기커밋 — 자급용 동봉) |

> BE 소스에 `DMF0044` 리터럴은 **0건**(generic call-proc). 화면 전용 BE 코드는 없다.
> 위 공용 titleset 엔드포인트가 본 화면 Column Setup 모달의 **재진입 복원 경로**라 동봉한다.
> 상세·생략 조건 = `_README.md` §5 M5.

---

## 생성 스크립트 / 기계 판독 산출물 (참고 — 이관 대상 아님)

| 파일 | 행 | 내용 |
|---|---:|---|
| `_generate_db_files.py` | 586 | A_DB 생성기 (SELECT only. PKG 첫 실행라인 assert / MERGE ON 키 PK 실측 / ON 키 유일성 assert) |
| `_generate_fe_files.py` | 117 | B_FE 생성기 (원본 무수정 복사. `index.ts` assert / import 분류 assert) |
| `_axis_counts.json` | 209 | 축별 실측 카운트 기계 판독본 |
| `_fe_manifest.json` | 191 | B_FE 파일·행수·locales 발췌 결과 |

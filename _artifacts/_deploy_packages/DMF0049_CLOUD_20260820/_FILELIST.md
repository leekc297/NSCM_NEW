# DMF0049_CLOUD_20260820 — 파일 목록

- 총 **43 파일 / 13,468 lines** (`_FILELIST.md` 자신 제외)
- 원천: 사내 `SCM_MGR@100.65.143.121:1521/OCGSCMD_P01` 라이브 실측 (2026-08-20)
- ⛔ 본 패키지는 **클라우드 미적용**. 사내/클라우드 DB 에 DDL/DML 실행 없음(SELECT only).

## A_DB — 적용 순서대로

| # | 파일 | 행수 | 내용 | 실측 카운트 |
|---:|---|---:|---|---|
| 1 | `A_DB/01_DDL_DEFAULT_ON_NULL.sql` | 275 | NOT NULL 컬럼 `DEFAULT ON NULL` 멱등 DDL | 22 컬럼 (표당 11 × 2표) |
| 2 | `A_DB/02_DDL_GTT.sql` | 201 | GTT 자급 DDL + 인덱스/TYPE 0행 축 명기 | GTT **6** / IDX **0** / TYPE **0** |
| 3 | `A_DB/03_DDL_SEQUENCE.sql` | 9 | `SEQ1_DM_PLN_SALES_ETC_REPORT_H` 멱등 | SEQ **1** |
| 4 | `A_DB/10_PKG_DMF0049_SPEC.sql` | 97 | PACKAGE SPEC (라이브 원문) | src **89** lines |
| 5 | `A_DB/11_PKG_DMF0049_BODY.sql` | 1,232 | PACKAGE BODY (라이브 원문) | src **1,224** lines / 마커 **3** |
| 6 | `A_DB/20_MENU_META_SYNC.sql` | 708 | MNU_M / PROGRAM / API_M / BTN / 권한 2축 | 1 / 1 / 19 / 19 / 4 / 70 |
| 7 | `A_DB/21_CMBO_SYNC.sql` | 186 | `SCM_ADM_CMBO_SQL_M` | **22** 종 / 22행 |
| 8 | `A_DB/22_SHEET_META_SYNC.sql` | 244 | 시트 메타 (SHEET_NAME 단위 재적재) | COLUMNS **90** / MEASURE **21** |
| 9 | `A_DB/23_MSG_LBL_MNU_SYNC.sql` | 441 | `SCM_ADM_MSG_M` (MSG/LBL/MNU 동일 표) | **24** 코드 / **72** 행 |
| 10 | `A_DB/24_PROC_M_SYNC.sql` | 746 | ⭐⭐ `SCM_ADM_PROC_M` (누락=PLS-00306) | **11** SP / **119** 행 |
| 11 | `A_DB/25_EXCEL_COLUMNS_SYNC.sql` | 9 | `SCM_ADM_EXCEL_COLUMNS` — **0행 축** 기록 | **0** (실행 DML 없음) |
| 12 | `A_DB/30_GRANT_SYNONYM.sql` | 142 | EXECUTE GRANT + 시노님 + 표 DML 권한 | GRANT 20 / SYN 21 / DML 8 |
| 13 | `A_DB/90_VERIFY.sql` | 331 | 적용 후 검증 V1~V11 (SELECT only) | 사내 전 항목 PASS |

## B_FE

| 파일 | 행수 | 비고 |
|---|---:|---|
| `B_FE/_IMPORT_CLOSURE.md` | 84 | import 폐포 전수 인벤토리 + 미동봉 PREREQ + 변경 요약 |
| `B_FE/configs-types/procedures.d.ts` | 4,300 | ⚠ 전 화면 공용 — DMF0049 블록 L3352~ |
| `B_FE/locales/KO.json` | 26 | LIVE 코드 **24종 발췌** (원본 914키) |
| `B_FE/locales/EN.json` | 26 | 〃 (원본 858키) |
| `B_FE/locales/CN.json` | 26 | 〃 (원본 852키) |
| **`B_FE/etc-sales-reports/`** | — | ⭐ **폴더 전체 18 파일** (아래) |

### `B_FE/etc-sales-reports/` — 18 파일 (viewRegistry 등록 단위)

| 파일 | 행수 | 2026-08-20 변경 |
|---|---:|---|
| `index.ts` | 1 | ⭐ viewRegistry glob 의 **유일한 등록 키** (누락 시 "Page Not Found") |
| `EtcSalesReports.tsx` | 481 | ✅ Report Type·Plan/Result 초기화 / 저장 Toast·스피너·연타 차단 |
| `EtcSalesReports.module.scss` | 147 | |
| `etc-sales-reports.constants.ts` | 124 | ✅ `dataScaleOf` / `DEFAULT_DATA_SCALE` |
| `etc-sales-reports.types.ts` | 33 | |
| `useEtcSalesReportsStore.ts` | 236 | |
| `__asis-mapping__.md` | 265 | ✅ REQ:CHAT-20260820-16/19 반영 |
| `components/EtcSalesReportsForm.tsx` | 159 | ✅ Report Type·Plan/Result 변경 초기화 |
| `components/EtcSalesReportsForm.module.scss` | 11 | |
| `components/EtcSalesReportsGrid.tsx` | 579 | ✅ 소수점 메타(`DATA_SCALE_NUMBER`) 구동 3자리 |
| `components/EtcSalesReportsModals.tsx` | 182 | ✅ |
| `utils/etc-sales-reports.api.ts` | 85 | |
| `utils/etc-sales-reports.division.ts` | 7 | |
| `utils/etc-sales-reports.editLock.ts` | 111 | |
| `utils/etc-sales-reports.gridCombos.ts` | 116 | |
| `utils/etc-sales-reports.merge.ts` | 130 | ✅ 병합 `activeSetKey` |
| `utils/etc-sales-reports.save.ts` | 201 | ✅ `staticChanged` (MSG00676 오탐 정정) |
| `utils/etc-sales-reports.validate.ts` | 18 | |

> ⚠ `EtcSalesReportsUtils.test.ts` (396행) 는 이번 작업에서 **삭제**됐다 — 패키지에 없다.
> 클라우드에 남아 있으면 제거할 것(삭제된 export 참조로 타입체크가 깨진다).

## C_BE — **변경 있음** (공용 titleSet 엔드포인트)

| 파일 | 행수 | 비고 |
|---|---:|---|
| `C_BE/_BE_CHANGE.md` | 66 | 근거·의존 경로·적용 주의 |
| `C_BE/admin-menu/MenuController.java` | 176 | `POST /admin/menu/{mnuId}/titleset[/search]` 신설 |
| `C_BE/admin-menu/MenuService.java` | 27 | |
| `C_BE/admin-menu/MenuServiceImpl.java` | 198 | |
| `C_BE/sql-admin/Menu.xml` | 102 | `DMF0002_GET_TITLESET_POPUP` / `SCM0002_SET_TITLESET_POPUP` CALLABLE |

> ⛔ 공유 파일 — **덮어쓰기 금지, diff 병합 필수**. DMF0044 패키지와 동일 파일이다.

## 루트

| 파일 | 행수 | 비고 |
|---|---:|---|
| `_README.md` | 298 | 적용 순서 / PREREQ / 08-20 적용분 / 축별 카운트 / 0행 축 / 미결 / VERIFY 결과 |
| `_generate_db_files.py` | 632 | A_DB 재생성기 (SELECT only, PKG 자기검증 assert 포함) |
| `_FILELIST.md` | — | 본 파일 |

## 이관 제외 (명시)

| 대상 | 실측 | 사유 |
|---|---:|---|
| `SCM_MST_TITLESET_USER` (`PROGRAM_ID='DMF0049'`) | 64행 (`MDF Reports` 30 + `mdfReports` 34) | 사용자 개인화 데이터 |
| `SCM_COM_SYS_LOG` (`MNU_ID` LIKE DMF0049) | 282행 | 로그 |
| `NSCM_UI_TEMP` / `NSCM_UI_TEMP_0211` / `NSCM_UI_TEMP_0304` | 각 2행 | 임시 표 |
| `SCM_MST_SHEET_COLUMNS_0408` / `_260408` | 각 42행 | 백업 표 |
| `PKG_DMF0044` 본문 | — | 별도 패키지 소관 (PREREQ 로 명기) |
| `features/master` 공용 컴포넌트 3본 | — | DMF0049 작업분 아님 (`B_FE/_IMPORT_CLOSURE.md` §2) |

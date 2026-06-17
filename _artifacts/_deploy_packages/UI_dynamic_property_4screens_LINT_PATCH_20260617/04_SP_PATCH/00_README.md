# DMF0043 SP Patch — 사내 → 클라우드 (2026-06-17)

## 배경

사용자 보고: DMF0043 클라우드에서 동적 컬럼 (Y#/M# 패턴) 미조회. 사내 환경은 정상.

진단 SQL 결과 (사용자 회신):
- 사내/클라우드 객체 30개 동일하나 **사내 9 객체가 2026-06-11 09:56 ~ 14:28 에 patched** (클라우드는 2026-06-05 ~ 09 구버전)
- 핵심: `DMF0043_GET_MAIN_SPREAD_TITLE` 가 dynamic 컬럼 (`FLAG#YYYYMM#CODE` 패턴) 생성하는 wrapper SP. 클라우드 구버전이 이 로직 누락.

## 차이 표

| 객체 | 사내 LAST_DDL | 클라우드 LAST_DDL |
|---|---|---|
| PKG_DMF0043 (PACKAGE) | 2026-06-11 09:56 | 2026-06-09 14:23 |
| PKG_DMF0043 (PACKAGE BODY) | 2026-06-11 09:56 | 2026-06-09 14:23 |
| DMF0043_GET_CONTRIBUTE_MAIN_DATA | 2026-06-11 14:28 | 2026-06-05 16:11 |
| DMF0043_GET_MAIN_SPREAD_TITLE ⭐ | 2026-06-11 09:56 | 2026-06-05 12:37 |
| DMF0043_GET_CONTRIBUTE_RATE_POPUP | 2026-06-11 09:56 | 2026-06-05 12:37 |
| DMF0043_GET_CONTRIBUTE_YEAR_POPUP | 2026-06-11 09:56 | 2026-06-04 18:42 |
| DMF0043_GET_CONT_VIEW_VERSIONPOPUP | 2026-06-11 09:56 | 2026-06-05 12:37 |
| DMF0043_GET_SALES_LIST_SPREAD_TITLE | 2026-06-11 09:56 | 2026-06-05 12:37 |
| DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO | 2026-06-11 11:12 | 2026-06-04 18:42 |

## 클라우드 > 사내 (적용 대상 X, 별도 검토)

3 객체가 클라우드 > 사내. 본 패치 대상 아님 — 클라우드 hotfix 가능성. 사용자 확인 후 결정.

| 객체 | 사내 | 클라우드 |
|---|---|---|
| DMF0043_GET_CONTRIBUTION_SALES_LIST | 21:27 | 23:01 |
| DMF0043_GET_MAIN_VARSION_DATA | 09:56 | 17:52 |
| DMF0043_SAVE_DM_MST_CONTRIBUTE_VER | 11:31 | 17:52 |

## 폴더 구조

```
04_SP_PATCH/
├─ 00_README.md (이 파일)
├─ 00_ALL_DMF0043_patch.sql                                  (통합 3,794 lines — 단일 실행 추천)
├─ 01_PKG_DMF0043_PACKAGE.sql                                 (102 lines)
├─ 02_PKG_DMF0043_PACKAGE_BODY.sql                            (1,780 lines)
├─ 03_DMF0043_GET_CONTRIBUTE_MAIN_DATA_PROCEDURE.sql          (845 lines)
├─ 04_DMF0043_GET_MAIN_SPREAD_TITLE_PROCEDURE.sql             (212 lines) ⭐ dynamic 컬럼 root cause
├─ 05_DMF0043_GET_CONTRIBUTE_RATE_POPUP_PROCEDURE.sql         (60 lines)
├─ 06_DMF0043_GET_CONTRIBUTE_YEAR_POPUP_PROCEDURE.sql         (79 lines)
├─ 07_DMF0043_GET_CONT_VIEW_VERSIONPOPUP_PROCEDURE.sql        (100 lines)
├─ 08_DMF0043_GET_SALES_LIST_SPREAD_TITLE_PROCEDURE.sql       (67 lines)
├─ 09_DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO_PROCEDURE.sql      (518 lines)
└─ 10_verify_compile.sql                                      (사후 검증 4 query)
```

## 적용 방법

### Option A — 통합 단일 실행 (권장)

DBeaver / SQLcl / SQL*Plus 로 클라우드 SCM_MGR 접속 후:

```
@00_ALL_DMF0043_patch.sql
```

→ 9 객체 모두 CREATE OR REPLACE. PL/SQL 종결자 `/` 포함.

### Option B — 개별 객체 적용 (단계별 디버깅 필요 시)

01 → 02 → 03 → ... → 09 순서로 실행. PACKAGE 가 BODY 보다 먼저.

### Step 3 — 검증

```
@10_verify_compile.sql
```

기대값:
- **Query 1** (INVALID 객체): 0 row
- **Query 2** (ALL_ERRORS): 0 row
- **Query 3** (SCMD_APP 권한): 9 row × `EXECUTE` (CREATE OR REPLACE 가 기존 GRANT 유지하므로 자동)
- **Query 4** (LAST_DDL): 9 객체 모두 SYSDATE 근처

### Step 4 — 브라우저 검증

DMF0043 화면 진입 → Version 선택 → 검색 → **dynamic 컬럼 (Y#YYYY 또는 M#YYYYMM 패턴) 표시 확인**.

## 의존성 (변경 없음, 적용 전 확인)

- GT 테이블 18종 (`GT_DMF0043_*`, `GT_GMST_TEMP_2`, `GT_GMST_TEMP2_2`, `GT_SDMCR_RESULTS_MST_2`, `GT_SDMCV_RESULTS_MST_2`) — 사내/클라우드 모두 2026-06-04~05 동일 → 변경 X
- SCM_MST_SHEET_COLUMNS (DMF0043 8 row) — 변경 X
- BLOCK 3/4/6 메타 — 변경 X

## 롤백

CREATE OR REPLACE 는 이전 버전 자동 폐기. 롤백 위해 사전 사내 DDL 백업 권장:

```sql
SELECT DBMS_METADATA.GET_DDL('PROCEDURE', 'DMF0043_GET_MAIN_SPREAD_TITLE', 'SCM_MGR') FROM DUAL;
-- 결과 CLOB 을 별도 파일로 백업
```

또는 클라우드 환경의 현재 DDL 추출 (apply 전).

## 작성 정보

- 추출 일자: 2026-06-17
- 추출 도구: `_artifacts/_diagnostics/extract_dmf0043_patch.py` (ALL_SOURCE 기반)
- 사내 환경: 121.162.245.167:2521/ESSCMD (SCM_MGR)
- 9 객체 / 3,794 lines 통합

# SYS0016 (게시판/notice-setup) — 클라우드 → 로컬(사내) DB 객체 역이관 패키지

> 클라우드에서 직접 생성한 UI(SYS0016)의 **DB 객체·배선 메타 전부**를 클라우드에서 추출하여 사내(OCGSCMD_P01)로 이관.
> 절차 표준 = hook **#122 `cloud-ui-db-object-fetch`** (본 패키지의 cloud/·local/ 스크립트가 재사용 템플릿 정본 —
> `DEFINE UI_ID / META_SINCE` 만 바꾸면 타 UI 동일 적용).
> 선례: `CLOUD_DDL_FETCH_20260729` (PKG_SYS0014). 작성 2026-08-04.

## 0. 원칙

- **DDL = DBMS_METADATA 원문 1바이트 무수정** (룰 22 / sp-body-minimal-change)
- **메타 = INSERT-only(NOT EXISTS) 멱등 + 감사컬럼 원본 보존** (2026-07-24 사용자 확정 — 방향 무관 준용)
- **발견 4축** (anti-simplification — 명칭 1패턴 금지): ①배선 메타(BTN_MPG→API_M, 권위) ②명칭 LIKE ③의존 폐포(ALL_DEPENDENCIES 재귀 — GTT/TYPE/SEQ 자급 의무) ④배선 메타 8테이블+MSG 신규분
- FE 파일은 본 패키지 범위 외 (git 로 이동)

## 1. 클라우드에서 수행 (sqlplus 또는 SQLcl — 클라우드 DB 접속 세션)

```
cd <이 패키지의 cloud/ 를 올린 디렉터리>
sqlplus SCM_MGR/<pw>@<클라우드DSN>

SQL> @01_DISCOVER_UI_OBJECTS.sql   -- ① 발견 보고서 → DISCOVER_SYS0016.txt
SQL> @02_EXTRACT_DDL.sql           -- ② DDL 추출     → SYS0016_DDL.sql
SQL> @03_EXTRACT_META.sql          -- ③ 메타 추출    → SYS0016_META.sql
```

- 실행 전 각 파일 상단 `DEFINE` 확인: `UI_ID='SYS0016'` / `OWNER='SCM_MGR'` / `META_SINCE='20260728'`(클라우드 작업 시작일로 조정)
- ①의 [B]+[C] 목록 = ②의 추출 대상 / [D] 카운트 = 로컬 90_VERIFY 대조 기준값 → **txt 를 반드시 함께 회수**
- ②③ 산출물에서 `!!` 오류 라인 0건 확인 (있으면 해당 객체명으로 개별 재추출)
- ③ 하단 주석: FE 가 콤보(useTabComboQueries)를 쓰면 SQL_ID 확인 후 CMBO emit 주석 해제·재실행
- 회수 파일 3개: `DISCOVER_SYS0016.txt` + `SYS0016_DDL.sql` + `SYS0016_META.sql` → 본 패키지 폴더에 저장

## 2. 로컬(사내 OCGSCMD_P01) 에서 수행

> 실행 도구 = 룰 32 옵션 C `_artifacts/_diagnostics/run_sql.sh`(docker sqlplus, CRLF 자동 제거) 또는 사내 sqlplus.
> ⚠ `ora.py exec` 는 단순 분할 실행기 — PKG BODY 포함 DDL 파일에 사용 금지.

| 순서 | 파일 | 내용 | 비고 |
|---|---|---|---|
| 1 | (사전) `90_VERIFY.sql` §1·§3 | 적용 전 현황 스냅샷 (기존재 객체·메타 확인) | 기존재 발견 시 diff 검토 후 진행 |
| 2 | `SYS0016_DDL.sql` (클라우드 산출물) | TYPE→SEQ→TABLE→VIEW→PKG SPEC→BODY→SP→FN 순 정렬본 | 기존재 ORA-00955 = skip 정상(멱등 분류). **구조가 다른 기존재**는 skip 이 갱신 못 함 — diff 후 개별 조치 (00A REBUILD 패턴) |
| 3 | `local/11_GRANT_SYNONYM.sql` | SCMD_APP GRANT+SYNONYM (UI 패턴 자동 + 공용 SP 수동 추가) | scmd-app-grant-mandatory |
| 4 | `SYS0016_META.sql` (클라우드 산출물) | 배선 메타 INSERT-only + COMMIT | 재실행 안전. 기존재 row 무변경 — 문구 차이는 목록화만 |
| 5 | `local/90_VERIFY.sql` | 객체 VALID·에러 0·메타 카운트=DISCOVER [D]·PROC_M positional·GRANT | **카운트 불일치 = 즉시 원인 규명** (누락 이관 금지) |
| 6 | FE smoke | 로컬 FE(SYS0016 라우트) 조회/저장 → SYS_LOG 오류 0 | oracle-db-workflow §2.5 |

## 3. 함정 (선례 반영)

- **GTT/TYPE 자급**: ①의 [C] 폐포에 GTT_YN='Y' 행이 있으면 그 DDL 이 ②에 포함됐는지 확인 — 누락 시 로컬 PKG 컴파일 ORA-00942 (DMF0003 사고, deploy-package-gtt-type-ddl)
- **공용 SP 재사용**(SCM0010_* 등 명칭이 UI 패턴 밖): ①[A] 의 API_URL 목록으로 식별 — 로컬 기존재 확인 후 미존재분만 ② 개별 추출 추가 + 11 GRANT 수동부 반영 (룰 22 §9.5)
- **PROC_M positional**: 90_VERIFY §4 에서 PROC_M 행수 ≠ ALL_ARGUMENTS 인자수 → PLS-00306 — 클라우드 재추출로 정정 (임의 작성 금지)
- **MSG/LBL**: ③의 MSG_M 은 META_SINCE 이후 신규분 전체 (전 화면 공통 포함 가능 — 로컬 NOT EXISTS 라 무해). locale JSON 은 FE(git) 몫 — 이관 제외 (사용자 확정 2026-07-24)
- 클라우드 OWNER 가 SCM_MGR 이 아니면 DEFINE OWNER 교체 (선례 01_PRECHECK 참조)

## 4. 파일 구성

```
SYS0016_CLOUD_FETCH_20260804_1310/
├── 00_README.md                      ← 본 절차서
├── cloud/01_DISCOVER_UI_OBJECTS.sql  ← 발견 4축 보고 (재사용 템플릿)
├── cloud/02_EXTRACT_DDL.sql          ← DDL 일괄 추출 (발견 기반, 적용순 정렬)
├── cloud/03_EXTRACT_META.sql         ← 메타 8테이블+MSG INSERT-only 생성 (범용 에미터)
├── local/11_GRANT_SYNONYM.sql        ← SCMD_APP GRANT+SYNONYM
├── local/90_VERIFY.sql               ← 적용 후 검증 (DISCOVER 대조)
└── (회수) DISCOVER_SYS0016.txt / SYS0016_DDL.sql / SYS0016_META.sql
```
